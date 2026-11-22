{lib, pkgs, ...}: {
  imports = [
    (import ../../../lib/package-options.nix "sunshine" [{
      id = "sunshine";
      available = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.sunshine;
      definitions.dconf.settings."org/gnome/desktop/screensaver".lock-enabled = false;
    }])
  ];
}
