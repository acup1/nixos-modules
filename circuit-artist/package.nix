{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "circuit-artist";
  version = "1.1.0-unstable-2026-10-04";

  src = pkgs.fetchFromGitHub {
    owner = "lets-all-be-stupid-forever";
    repo = "circuit-artist";
    rev = "1c08933e77e718dfd2b427cdfdd9cb12ba201c84";
    fetchSubmodules = true;
    hash = "sha256-BDLL62mSALERTajmE/kmBZHPfEjwVDBL4k7NhGOOrOs=";
  };

  # Fix glibc 2.40+ / C23 once_flag conflict in tinycthread without patching sources
  NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE -include stdlib.h";

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = with pkgs; [
    gtk3
    gsettings-desktop-schemas
    libGL
    libx11
    libxcursor
    libxrandr
    libxinerama
    libxi
    libxext
    libxfixes
    libxcb
  ];

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "circuit-artist";
      desktopName = "Circuit Artist";
      genericName = "Digital Logic Simulation Game";
      comment = "A Digital Logic Simulation Game - Every Circuit Is An Image";
      exec = "circuit-artist";
      icon = "circuit-artist";
      categories = [ "Game" "Simulation" "LogicGame" ];
      keywords = [ "game" "logic" "circuits" "simulation" ];
      startupNotify = true;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/circuit-artist
    cp ca $out/bin/.ca-real
    cp cap $out/bin/cap

    # Assets
    cp -r ../assets $out/share/circuit-artist/assets

    # Icons
    mkdir -p $out/share/icons/hicolor/24x24/apps \
             $out/share/icons/hicolor/32x32/apps \
             $out/share/icons/hicolor/48x48/apps \
             $out/share/pixmaps

    cp $out/share/circuit-artist/assets/imgs/icon24.png $out/share/icons/hicolor/24x24/apps/circuit-artist.png
    cp $out/share/circuit-artist/assets/imgs/icon32.png $out/share/icons/hicolor/32x32/apps/circuit-artist.png
    cp $out/share/circuit-artist/assets/imgs/icon48.png $out/share/icons/hicolor/48x48/apps/circuit-artist.png
    cp $out/share/circuit-artist/assets/imgs/icon48.png $out/share/pixmaps/circuit-artist.png

    cat << 'EOF' > $out/bin/ca
#!/bin/sh
if [ -z "$CA_DATA_DIR" ]; then
  export CA_DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/circuit-artist"
  mkdir -p "$CA_DATA_DIR"
fi
export CA_ASSET_DIR="''${CA_ASSET_DIR:-@out@/share/circuit-artist/assets}"
exec "@out@/bin/.ca-real" "$@"
EOF
    substituteInPlace $out/bin/ca --replace-fail "@out@" "$out"
    chmod +x $out/bin/ca

    ln -s $out/bin/ca $out/bin/circuit-artist
    ln -s $out/bin/cap $out/bin/circuit-artist-player

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "A Digital Logic Simulation Game - Every Circuit Is An Image";
    homepage = "https://github.com/lets-all-be-stupid-forever/circuit-artist";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "circuit-artist";
  };
}
