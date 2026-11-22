{config, lib, pkgs, ...}: let
  cfg = config.components.gnome-theming;
  defaultExtensions = [
    "appindicator"
    "blur-my-shell"
    "dash-to-dock"
    "desktop-icons-ng-ding"
    "desktop-clock"
    "rounded-corners"
    "tray-icons-reloaded"
  ];
  enabledExtensions = lib.filter (name: cfg.enabledPackages.${name} or true) cfg.extensions;
  packages = map (name: pkgs.gnomeExtensions.${name} or null) enabledExtensions;
in {
  imports = [(import ../../../lib/package-options.nix "gnome-theming" (
    map (id: {inherit id;}) defaultExtensions
  ))];

  options.components.gnome-theming.extensions = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = defaultExtensions;
    description = "Extensions to install and enable, by nixpkgs gnomeExtensions attribute name.";
  };
  config.programs.gnome-shell = {
    enable = true;
    extensions = map (package: {inherit package;}) (
      lib.filter (p: p != null && lib.meta.availableOn pkgs.stdenv.hostPlatform p) packages
    );
  };
}
