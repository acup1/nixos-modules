{lib, pkgs, ...}: let
  cask = import ../lib/darwin-cask.nix lib;
in {
  imports = [
    (import ../lib/named-packages.nix "TV" {names = ["libcec"];})
    (import ../lib/package-options.nix "TV" [
      (cask "kdeconnect-kde" "kde-connect" // {
        available = pkgs.stdenv.hostPlatform.system == "aarch64-darwin";
        default = false;
      })
    ])
    (import ../lib/component-packages.nix "TV" "system")
  ];
}
