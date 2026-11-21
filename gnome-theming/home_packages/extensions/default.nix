{config, lib, pkgs, ...}: let
  cfg = config.components.gnome-theming;
  packages = map (name: pkgs.gnomeExtensions.${name} or null) cfg.extensions;
in {
  options.components.gnome-theming.extensions = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [
      "appindicator"
      "blur-my-shell"
      "dash-to-dock"
      "desktop-icons-ng-ding"
      "desktop-clock"
      "rounded-corners"
      "tray-icons-reloaded"
    ];
    description = "Extensions to install and enable, by nixpkgs gnomeExtensions attribute name.";
  };
  config.programs.gnome-shell = {
    enable = true;
    extensions = map (package: {inherit package;}) (
      lib.filter (p: p != null && lib.meta.availableOn pkgs.stdenv.hostPlatform p) packages
    );
  };
}
