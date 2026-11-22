{pkgs, ...}: {
  imports = [(import ../../../../lib/package-options.nix "common" [{
    id = "waybar";
    package = pkgs.waybar;
    definitions.xdg.configFile.waybar.source = ./.config/waybar;
  }])];
}
