{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  components.common.packages = with pkgs; [
    waybar
  ];
  xdg.configFile."waybar" = lib.mkIf (lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.waybar) {
    source = ./.config/waybar;
  };
}
