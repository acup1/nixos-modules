{lib, pkgs, inputs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  zen = inputs.zen-browser.packages.${system}.default or null;
in {
  components.macos-packages.packages = lib.optional (zen != null) zen;
}
