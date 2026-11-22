{pkgs, ...}: {
  imports = [(import ../../../lib/package-options.nix "common" [
    {
      id = "maliit-keyboard";
      definitions.environment.sessionVariables.MALIIT_PLUGINS_DIR = "${pkgs.maliit-keyboard}/lib/maliit/plugins";
    }
    {id = "pass-secret-service"; definitions.services.passSecretService.enable = true;}
  ])];

  config.environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
