# A selector can use the exported modules directly or customize the selected bundle.
{
  nixos ? null,
  darwin ? null,
  home ? null,
  homePlatform ? null,
} @ component: let
  layers = builtins.removeAttrs component ["homePlatform"];

  withConfig = {
    enable ? true,
    nixos ? {},
    darwin ? {},
    home ? {},
  }: let
    overrides = {inherit nixos darwin home;};
    configureLayer = layer: path: {lib, specialArgs, ...}: let
      # The host flake passes its target system as a special argument so
      # platform-specific imports can be skipped before evaluating their inputs.
      system = specialArgs.system or (specialArgs.pkgs.stdenv.hostPlatform.system or builtins.currentSystem);
      supported = layer != "home" || homePlatform == null || lib.hasSuffix "-${homePlatform}" system;
    in {
      imports = lib.optionals supported [path overrides.${layer}];
    };
  in
    if enable
    then builtins.mapAttrs configureLayer layers // {
      # Lets selectors customize an existing import without duplicating its settings.
      _componentPath = builtins.dirOf (toString layers.${builtins.head (builtins.attrNames layers)});
    }
    else {};
in
  (withConfig {}) // {inherit withConfig;}
