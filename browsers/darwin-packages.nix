{pkgs, inputs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  zen = inputs.zen-browser or (
    if system == "aarch64-darwin"
    then (import ./default.nix).inputs.zen-browser
    else {}
  );
in [
  {
    id = "zen-browser";
    package = zen.packages.${system}.default or null;
  }
]
