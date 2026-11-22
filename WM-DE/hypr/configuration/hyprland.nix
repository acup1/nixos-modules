{config, lib, ...}: {
  config = lib.mkIf config.components.hypr.enabledPackages.hyprland {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = false;
    };
  };
}
