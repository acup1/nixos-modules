{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) hostPlatform;
  caelestia-shell = builtins.getFlake "github:caelestia-dots/shell";
  shellPackage = caelestia-shell.packages.${hostPlatform.system}.default or null;
in {
  components.caelestia-shell.packages = lib.optional (hostPlatform.isLinux && shellPackage != null) shellPackage;
}
