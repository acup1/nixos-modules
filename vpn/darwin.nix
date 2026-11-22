{lib, pkgs, ...}: let
  cask = import ../lib/darwin-cask.nix lib;
in {
  imports = [
    (import ../lib/component-packages.nix "vpn" "system")
    (import ../lib/darwin-package-options.nix "vpn" [
      (cask "amnezia-vpn" "amneziavpn" // {available = pkgs.stdenv.hostPlatform.system == "x86_64-darwin";})
      (cask "clash-verge-rev" "clash-verge-rev")
    ])
  ];
}
