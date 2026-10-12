{
  lib,
  stdenv,
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
  repoName ? pname,
  archivePrefix ? "${pname}-${version}-linux-x86_64",
  tarName ? "${archivePrefix}.tar.gz",
  hash,
  description ? "ArtCraft application",
  metaName ? pname,
}:
stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/storytold/${repoName}/releases/download/v${version}/${tarName}";
    inherit hash;
  };

  # Source archive contains a top-level directory like "${archivePrefix}"
  sourceRoot = archivePrefix;

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

  # Allow missing optional libraries that winit / egui dlopen conditionally
  autoPatchelfIgnoreMissingDeps = true;

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
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = metaName;
  };
}
