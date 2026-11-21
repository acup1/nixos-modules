{pkgs, ...}: {
  programs.gnome-shell = {
    enable = true;
    extensions = map (package: {inherit package;}) (with pkgs.gnomeExtensions; [
      appindicator
      blur-my-shell
      dash-to-dock
      desktop-icons-ng-ding
      desktop-clock
      rounded-corners
      tray-icons-reloaded
    ]);
  };
}
