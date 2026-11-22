{pkgs, inputs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  zen = inputs.zen-browser.packages.${system}.default or null;
in {
  imports = [
    (import ../../lib/package-options.nix "macos-packages" [{
      id = "zen-browser";
      package = zen;
    }])
  ];
}
