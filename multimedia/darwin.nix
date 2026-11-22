{lib, ...}: let
  cask = import ../lib/darwin-cask.nix lib;
in {
  imports = [
    (import ../lib/component-packages.nix "multimedia" "system")
    (import ../lib/darwin-package-options.nix "multimedia" [
      (cask "obs-studio" "obs")
    ])
  ];
}
