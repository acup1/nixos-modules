name: scope: {
  config,
  lib,
  pkgs,
  ...
}: let
  availablePackages = import ./available-packages.nix pkgs;
  packages = availablePackages config.components.${name}.packages;
  profileOption =
    if scope == "home"
    then ["home" "packages"]
    else ["environment" "systemPackages"];
in {
  key = "${toString ./component-packages.nix}:${name}:${scope}";

  options.components.${name}.packages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [];
    description = "Packages contributed by the ${name} component.";
  };

  # An empty definition at normal priority would discard mkDefault packages.
  config = lib.mkIf (packages != []) (lib.setAttrByPath profileOption packages);
}
