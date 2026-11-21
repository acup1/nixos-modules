{
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
in {
  components.hypr.packages = lib.optional (iio != null) iio;
  wayland.windowManager.hyprland = lib.mkIf (hyprland != null && lib.meta.availableOn hostPlatform hyprland) {
    enable = true;
    package = hyprland;
    configType = "lua";

    extraConfig = ''
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
  # xdg.configFile."hypr".source = ./.config/hypr;
}
