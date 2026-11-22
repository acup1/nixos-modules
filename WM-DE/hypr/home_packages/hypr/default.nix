{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}: let
  fallback = (builtins.getFlake "path:${toString ../../inputs}").inputs;
  inputs = {
    hyprland = specialArgs.inputs.hyprland or fallback.hyprland;
    iio-hyprland = specialArgs.inputs.iio-hyprland or fallback.iio-hyprland;
  };
  inherit (pkgs.stdenv) hostPlatform;
  hyprland = inputs.hyprland.packages.${hostPlatform.system}.hyprland or null;
  iio = inputs.iio-hyprland.packages.${hostPlatform.system}.default or null;
  enabled = config.components.hypr.enabledPackages;
  common = config.components.common.enabledPackages;
in {
  imports = [(import ../../../../lib/package-options.nix "hypr" [
    {
      id = "hyprland";
      available = hyprland != null && lib.meta.availableOn hostPlatform hyprland;
      definitions.wayland.windowManager.hyprland = {
          enable = true;
          package = hyprland;
          configType = "lua";

          extraConfig = ''
            local dmsEnabled = ${lib.boolToString common.dank-material-shell}
            local waybarEnabled = ${lib.boolToString common.waybar}
            local grimblastEnabled = ${lib.boolToString enabled.grimblast}
            local iioEnabled = ${lib.boolToString (enabled.iio-hyprland && iio != null && lib.meta.availableOn hostPlatform iio)}
            ${builtins.readFile ./.config/hypr/settings.lua}
            ${builtins.readFile ./.config/hypr/autostart.lua}
            ${builtins.readFile ./.config/hypr/inputnbindings.lua}
          '';
          systemd = {
            enable = true;
            variables = [
              "DISPLAY"
              "HYPRLAND_INSTANCE_SIGNATURE"
              "WAYLAND_DISPLAY"
              "XDG_CURRENT_DESKTOP"
              "XDG_SESSION_TYPE"
            ];
          };

          plugins = [
            # inputs.hyprgrass.packages.${hostPlatform.system}.default
            # inputs.Hyprspace.packages.${hostPlatform.system}.Hyprspace
          ];
      };
    }
    {id = "grimblast";}
    {id = "iio-hyprland"; package = iio;}
  ])];
}
