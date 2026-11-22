{
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) hostPlatform;
  caelestia-shell = builtins.getFlake "github:caelestia-dots/shell";
  shellPackage = caelestia-shell.packages.${hostPlatform.system}.default or null;
in {
  imports = [(import ../../lib/package-options.nix "caelestia-shell" [{
    id = "caelestia-shell";
    available = hostPlatform.isLinux;
    package = shellPackage;
  }])];
}
