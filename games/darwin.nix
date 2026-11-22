{lib, pkgs, ...}: let
  cask = import ../lib/darwin-cask.nix lib;
in {
  imports = [
    (import ../lib/component-packages.nix "games" "system")
    (import ../lib/darwin-package-options.nix "games" [
      {id = "gnome-sudoku"; package = pkgs.gnome-sudoku or null;}
      (cask "steam" "steam")
    ])
  ];
}
