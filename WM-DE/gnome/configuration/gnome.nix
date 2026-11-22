{...}: {
  imports = [(import ../../../lib/package-options.nix "gnome" [{
    id = "gnome-shell";
    definitions = {
      services.desktopManager.gnome.enable = true;
    };
  }])];
}
