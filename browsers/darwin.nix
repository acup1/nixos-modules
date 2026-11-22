{inputs, lib, pkgs, ...}: let
  cask = import ../lib/darwin-cask.nix lib;
in {
  imports = [
    (import ../lib/component-packages.nix "browsers" "system")
    (import ../lib/darwin-package-options.nix "browsers" (import ./darwin-packages.nix {inherit inputs pkgs;}))
    (import ../lib/package-options.nix "browsers" [
      (cask "google-chrome" "google-chrome" // {default = false;})
      (cask "tor-browser" "tor-browser" // {default = false;})
    ])
  ];
}
