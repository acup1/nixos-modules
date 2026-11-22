{lib, pkgs, ...}: let
  cask = import ../lib/darwin-cask.nix lib;
in {
  imports = [
    (import ../lib/component-packages.nix "file-viewers" "system")
    (import ../lib/darwin-package-options.nix "file-viewers" [
      {id = "mpv"; package = pkgs.mpv or null;}
      (cask "vlc" "vlc")
    ])
  ];
}
