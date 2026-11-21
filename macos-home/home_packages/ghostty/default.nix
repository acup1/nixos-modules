{lib, pkgs, ...}: let
  ghostty = pkgs.ghostty-bin or null;
  ghosttyAvailable = ghostty != null && lib.meta.availableOn pkgs.stdenv.hostPlatform ghostty;
in {
  components.macos-home.packages = lib.optional ghosttyAvailable ghostty;
  xdg.configFile."ghostty" = lib.mkIf ghosttyAvailable {
    source = ./.config/ghostty;
  };
}
