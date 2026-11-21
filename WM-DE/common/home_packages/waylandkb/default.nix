{
  lib,
  pkgs,
  specialArgs,
  ...
}: let
  fallback = (builtins.getFlake "path:${toString ../../inputs}").inputs;
  inputs = {
    waylandkb = specialArgs.inputs.waylandkb or fallback.waylandkb;
  };
  package = inputs.waylandkb.packages.${pkgs.stdenv.hostPlatform.system}.default or null;
in {
  components.common.packages = lib.optional (package != null) package;
}
