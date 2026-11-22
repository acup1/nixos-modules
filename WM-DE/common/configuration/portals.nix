{pkgs, ...}: {
  imports = [(import ../../../lib/package-options.nix "common" [{
    id = "xdg-desktop-portal-gtk";
    definitions = {
      xdg.portal = {
        enable = true;
        config.common.default = [ "gtk" ];
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    };
  }])];
}
