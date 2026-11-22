{config, lib, pkgs, ...}: let
  enabled = config.components.common.enabledPackages;
in {
  imports = [(import ../../../../lib/package-options.nix "common" [
    {
      id = "bibata-cursors";
      definitions.home.pointerCursor = {
        enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };
    }
    {
      id = "orchis-theme";
      definitions.gtk = {
        enable = true;
        theme = {
          package = pkgs.orchis-theme;
          name = "Orchis-Grey-Dark-Compact";
        };
        gtk4.theme = config.gtk.theme;
      };
    }
    {
      id = "tela-icon-theme";
      definitions.gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.tela-icon-theme;
          name = "Tela-black";
        };
      };
    }
  ])];

  config.programs.dank-material-shell.settings.cursorSettings =
    lib.mkIf (enabled.dank-material-shell && enabled.bibata-cursors) {
      theme = config.home.pointerCursor.name;
      size = config.home.pointerCursor.size;
    };
}
