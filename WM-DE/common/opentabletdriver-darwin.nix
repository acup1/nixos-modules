{lib, stdenvNoCC, fetchurl}: let
  version = "0.6.8.1";
  assets = {
    aarch64-darwin = {arch = "arm64"; hash = "sha256-u9OVe6WogJ43fNoLdGyaBXjTgpcDdajuP1HbaPey4yg=";};
    x86_64-darwin = {arch = "x64"; hash = "sha256-yKkL1WJ/Ph9zYNVTSEiX8AZBaz/IRnTvnCzd+xuUEwU=";};
  };
  inherit (assets.${stdenvNoCC.hostPlatform.system}) arch hash;
in stdenvNoCC.mkDerivation {
  pname = "opentabletdriver";
  inherit version;
  src = fetchurl {
    url = "https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${version}/OpenTabletDriver-${version}_osx-${arch}.tar.gz";
    inherit hash;
  };
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;
  installPhase = ''
    runHook preInstall
    mkdir -p "$TMPDIR/opentabletdriver-release" "$out/Applications"
    tar -xf "$src" -C "$TMPDIR/opentabletdriver-release"
    mapfile -d "" bundles < <(find "$TMPDIR/opentabletdriver-release" -type d -name 'OpenTabletDriver.app' -prune -print0)
    test "''${#bundles[@]}" -eq 1
    cp -R "''${bundles[0]}" "$out/Applications/"
    runHook postInstall
  '';
  meta = {
    description = "OpenTabletDriver macOS application";
    homepage = "https://opentabletdriver.net/";
    license = lib.licenses.lgpl3Plus;
    platforms = builtins.attrNames assets;
    sourceProvenance = [lib.sourceTypes.binaryNativeCode];
  };
}
