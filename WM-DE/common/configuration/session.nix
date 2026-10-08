{pkgs, ...}: {
  environment.sessionVariables = {
    MALIIT_PLUGINS_DIR = "${pkgs.maliit-keyboard}/lib/maliit/plugins";
    NIXOS_OZONE_WL = "1";
  };

  services.passSecretService.enable = true;
}
