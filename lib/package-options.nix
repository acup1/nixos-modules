component: entries: {config, lib, pkgs, ...}: let
  enabled = config.components.${component}.enabledPackages;
  supported = import ./package-supported.nix pkgs;

  declare = entry: lib.nameValuePair entry.id (lib.mkOption {
    type = lib.types.bool;
    default = entry.default or true;
    description = entry.description or "Enable ${entry.id} in the ${component} component.";
  });

  configure = entry: lib.mkIf (enabled.${entry.id} && (entry.available or true)) (lib.mkMerge (
    lib.optional (entry ? definitions) (lib.mkIf (
      !(entry ? package)
      || supported entry.package
    ) entry.definitions)
    ++ lib.optional (entry ? package) {
      # Keep ordinary package expressions lazy so a host can replace the list.
      components.${component}.packages = [entry.package];
    }
  ));
in {
  options.components.${component}.enabledPackages = lib.listToAttrs (map declare entries);
  config = lib.mkMerge (map configure entries);
}
