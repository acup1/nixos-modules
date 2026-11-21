{pkgs, ...}: {
  components.gnome.packages = with pkgs; [ gnomeExtensions.screen-rotate ];
}
