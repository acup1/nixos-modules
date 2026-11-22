{lib, pkgs, ...}: let
  cask = import ../lib/darwin-cask.nix lib;
in {
  imports = [
    (import ../lib/component-packages.nix "graphics" "system")
    (import ../lib/darwin-package-options.nix "graphics" [
      {id = "darktable"; package = pkgs.darktable or null;}
      {id = "coin3d"; package = pkgs.coin3d or null;}
      (cask "freecad" "freecad")
    ])
  ];
}
