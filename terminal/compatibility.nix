legacy: scope: groups: {config, lib, options, ...}: let
  aliases = lib.concatMap (
    {name, ids}: map (
      id: lib.mkAliasOptionModule
        ["components" legacy "enabledPackages" id]
        ["components" name "enabledPackages" id]
    ) ids
  ) groups;
  # If both legacy Home layers are selected, terminal owns their shared defaults.
  legacyOwnsDefaults = legacy != "macos-home" || !lib.hasAttrByPath ["components" "terminal" "packages"] options;
in {
  imports = [(import ../lib/component-packages.nix legacy scope)] ++ aliases;
  config.components.${legacy}.packages = lib.mkMerge (map (
    {name, ...}: lib.mkIf (legacyOwnsDefaults && !config.components.${name}.standalone)
      config.components.${name}.packages
  ) groups);
}
