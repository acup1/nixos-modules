{lib, pkgs, ...}: let
  inherit (pkgs.stdenv) hostPlatform;
in {
  components.games.packages = with pkgs; [
    wineWow64Packages.waylandFull

    gnome-sudoku
  ]
  # Nixpkgs' Bottles wrapper uses the i686 package set.
  ++ lib.optional (hostPlatform.isLinux && hostPlatform.isx86) bottles;
}
