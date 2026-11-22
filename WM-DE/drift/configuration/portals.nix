{config, lib, pkgs, ...}: {
  config.xdg.portal = lib.mkIf config.components.drift.enabledPackages.driftwm {
    config.driftwm = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      "org.freedesktop.impl.portal.Screenshot" = "wlr";
      "org.freedesktop.impl.portal.Inhibit" = "none";
    };
    wlr.enable = true;
    wlr.settings.screencast = {
      output_name = "eDP-1";
      chooser_type = lib.mkIf config.components.common.enabledPackages.slurp "simple";
      chooser_cmd = lib.mkIf config.components.common.enabledPackages.slurp "${pkgs.slurp}/bin/slurp -f %o -or";
    };
  };
}
