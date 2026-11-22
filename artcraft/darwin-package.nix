{ lib, stdenvNoCC, fetchurl, _7zz, unzip }:
{
  pname,
  version,
  releaseUrl,
  hash,
  cliHash,
  bundleName,
  description,
}:
let
  cliArchive = "${pname}-cli-${version}-macos-universal";
  cliSrc = if cliHash == null then null else fetchurl {
    url = "${releaseUrl}/${cliArchive}.zip";
    hash = cliHash;
  };
in stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "${releaseUrl}/${pname}-${version}-macos-universal.dmg";
    inherit hash;
  };

  nativeBuildInputs = [ _7zz ] ++ lib.optional (cliSrc != null) unzip;
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  # Preserve the upstream Mach-O and application bundle signatures.
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    7zz x -y -o"$TMPDIR/artcraft-dmg" "$src" '-ir!*.app'
    mapfile -d "" bundles < <(find "$TMPDIR/artcraft-dmg" -type d -name ${lib.escapeShellArg "${bundleName}.app"} -prune -print0)
    if [[ "''${#bundles[@]}" != 1 ]]; then
      echo "Expected one ${bundleName}.app in the upstream disk image" >&2
      exit 1
    fi

    mkdir -p "$out/Applications" "$out/bin"
    cp -R "''${bundles[0]}" "$out/Applications/"
    executable="$out/Applications/${bundleName}.app/Contents/MacOS/${bundleName}"
    test -x "$executable"
    ln -s "$executable" "$out/bin/${pname}"

    ${lib.optionalString (cliSrc != null) ''
      unzip -q ${cliSrc} -d "$TMPDIR/artcraft-cli"
      install -m755 "$TMPDIR/artcraft-cli/${cliArchive}/${pname}-cli" "$out/bin/${pname}-cli"
      mkdir -p "$out/share/doc/${pname}-cli"
      find "$TMPDIR/artcraft-cli/${cliArchive}" -maxdepth 1 -type f ! -name ${lib.escapeShellArg "${pname}-cli"} \
        -exec install -m644 {} "$out/share/doc/${pname}-cli/" \;
    ''}

    runHook postInstall
  '';

  meta = with lib; {
    inherit description;
    homepage = "https://getartcraft.com/apps";
    license = with licenses; [ mit asl20 ];
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
    mainProgram = pname;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
