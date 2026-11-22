{lib, stdenvNoCC, fetchurl, _7zz}: let
  version = "2.5.0";
  assets = {
    aarch64-darwin = {arch = "arm64"; hash = "sha256-PGdw9en3bOxoR/+UsqIHsOxIvlgr83LMftbSQqyTX98=";};
    x86_64-darwin = {arch = "x64"; hash = "sha256-JpKnVINdn7MqMl0mejcQvpMdOKulfVbtyECIZI8LwEo=";};
  };
  inherit (assets.${stdenvNoCC.hostPlatform.system}) arch hash;
in stdenvNoCC.mkDerivation {
  pname = "muffon";
  inherit version;
  src = fetchurl {
    url = "https://github.com/staniel359/muffon/releases/download/v${version}/muffon-${version}-mac-${arch}.dmg";
    inherit hash;
  };
  nativeBuildInputs = [_7zz];
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;
  installPhase = ''
    runHook preInstall
    7zz x -y -o"$TMPDIR/muffon-dmg" "$src" '-ir!*.app'
    mapfile -d "" bundles < <(find "$TMPDIR/muffon-dmg" -type d -iname 'muffon.app' -prune -print0)
    test "''${#bundles[@]}" -eq 1
    mkdir -p "$out/Applications"
    cp -R "''${bundles[0]}" "$out/Applications/"
    runHook postInstall
  '';
  meta = {
    description = "Muffon music streaming browser";
    homepage = "https://muffon.netlify.app/";
    license = lib.licenses.agpl3Only;
    platforms = builtins.attrNames assets;
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
  };
}
