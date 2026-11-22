{lib, ...}: let
  cask = import ../lib/darwin-cask.nix lib;
in {
  imports = [
    (import ../lib/component-packages.nix "photoGIMP" "system")
    (import ../lib/package-options.nix "photoGIMP" [
      (cask "gimp3" "gimp" // {default = false;})
    ])
  ];
}
