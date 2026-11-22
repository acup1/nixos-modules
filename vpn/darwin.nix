{config, lib, pkgs, ...}: let
  cask = import ../lib/darwin-cask.nix lib;
in {
  imports = [
    (import ../lib/component-packages.nix "vpn" "system")
    (import ../lib/package-options.nix "vpn" [
      (cask "amnezia-vpn" "amneziavpn" // {
        default = pkgs.stdenv.hostPlatform.isx86_64
          && (config.components.macos-packages.enabledPackages.amnezia-vpn or true);
      })
    ])
    (import ../lib/darwin-package-options.nix "vpn" [
      (cask "clash-verge-rev" "clash-verge-rev")
    ])
  ];
}
