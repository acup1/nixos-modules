{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  cups,
  dbus,
  fontconfig,
  freetype,
  libGL,
  libglvnd,
  libxkbcommon,
  vulkan-loader,
  wayland,
  wayland-protocols,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  libxcb,
}: {
  pname,
  version,
  releaseUrl,
  hash,
  description,
}: let
  archivePrefix = "${pname}-${version}-linux-${stdenv.hostPlatform.parsed.cpu.name}";
in stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "${releaseUrl}/${archivePrefix}.tar.gz";
    inherit hash;
  };

  sourceRoot = archivePrefix;
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    cups.lib
    dbus
    fontconfig
    freetype
    libGL
    libglvnd
    libxkbcommon
    stdenv.cc.cc.lib
    vulkan-loader
    wayland
    wayland-protocols
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxrandr
    libxrender
    libxcb
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin share $out/

    runHook postInstall
  '';

  postFixup = ''
    # Apps dlopen graphics, windowing, and audio libraries at runtime (winit, egui, cpal, ash/vulkan).
    runtimeLibs="${lib.makeLibraryPath [
      alsa-lib
      libGL
      libglvnd
      libxkbcommon
      vulkan-loader
      wayland
      libx11
      libxcursor
      libxext
      libxi
      libxinerama
      libxrandr
      libxrender
      libxcb
    ]}"

    for bin in "$out"/bin/*; do
      if [ -f "$bin" ] && [ -x "$bin" ]; then
        wrapProgram "$bin" \
          --prefix LD_LIBRARY_PATH : "$runtimeLibs"
      fi
    done
  '';

  meta = with lib; {
    inherit description;
    homepage = "https://getartcraft.com/apps";
    license = with licenses; [ mit asl20 ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = pname;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
