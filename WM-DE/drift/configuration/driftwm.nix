{specialArgs, lib, pkgs, ...}: let
  fallback = (builtins.getFlake "path:${toString ../inputs}").inputs;
  inputs = {
    driftwm = specialArgs.inputs.driftwm or fallback.driftwm;
  };
  inherit (pkgs.stdenv) hostPlatform;
  driftwm = inputs.driftwm.packages.${hostPlatform.system}.default or null;
  available = driftwm != null && lib.meta.availableOn hostPlatform driftwm;
in {
  imports = [
    inputs.driftwm.nixosModules.default
    (import ../../../lib/package-options.nix "drift" [{
      id = "driftwm";
      inherit available;
      definitions.programs.driftwm = {
        enable = true;
        package = driftwm.overrideAttrs (old: {
          patches = (old.patches or []) ++ [
            ../home_packages/driftwm/patches/overview-focus.patch
          ];
        });
      };
    }])
  ];
}
