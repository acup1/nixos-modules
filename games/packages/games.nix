{pkgs, ...}: let
  inherit (pkgs.stdenv) hostPlatform;
in {
  imports = [(import ../../lib/package-options.nix "games" (with pkgs; [
    {id = "wine-wayland"; package = wineWow64Packages.waylandFull; available = hostPlatform.isLinux && hostPlatform.isx86;}
    {id = "gnome-sudoku"; package = gnome-sudoku;}
    {id = "bottles"; package = bottles; available = hostPlatform.isLinux && hostPlatform.isx86;}
  ]))];
}
