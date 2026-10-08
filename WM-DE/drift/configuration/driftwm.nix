{inputs, pkgs, ...}: {
  imports = [ inputs.driftwm.nixosModules.default ];

  programs.driftwm = {
    enable = true;
    package = inputs.driftwm.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ../home_packages/driftwm/patches/overview-focus.patch
      ];
    });
  };
}
