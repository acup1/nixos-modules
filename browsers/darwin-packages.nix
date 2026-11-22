{pkgs, inputs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) system;
in [
  {
    id = "zen-browser";
    package = inputs.zen-browser.packages.${system}.default or null;
  }
]
