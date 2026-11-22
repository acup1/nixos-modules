{lib, pkgs, ...}: let
  cask = import ../lib/darwin-cask.nix lib;
  optIn = entry: entry // {default = false;};
in {
  imports = [
    (import ../lib/component-packages.nix "dev" "system")
    (import ../lib/darwin-package-options.nix "dev" (import ./darwin-packages.nix {inherit lib pkgs;}))
    (import ../lib/package-options.nix "dev" (map optIn [
      (cask "arduino-ide" "arduino-ide")
      # Keep Clang's cc/c++ aliases and the existing Rust toolchain ahead of the optional alternatives.
      {id = "gcc"; package = lib.setPrio 20 pkgs.gcc;}
      {id = "libgccjit"; package = pkgs.libgccjit or null;}
      {id = "rustup"; package = lib.setPrio 20 pkgs.rustup;}
      {id = "scdoc"; package = pkgs.scdoc or null;}
    ]))
  ];
}
