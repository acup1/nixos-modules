name: scope: {config, lib, pkgs, ...} @ args: let
  profile = import ../lib/component-packages.nix name scope args;
in
  profile // {
    options = lib.recursiveUpdate profile.options {
      components.${name}.standalone = lib.mkOption {
        type = lib.types.bool;
        default = false;
        internal = true;
        description = "Install the packages without the legacy terminal bundle.";
      };
    };
    config = lib.mkIf config.components.${name}.standalone profile.config;
  }
