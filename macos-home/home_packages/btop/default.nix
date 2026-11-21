{pkgs, ...}: {
  home.packages = [pkgs.btop];
  xdg.configFile."btop/btop.conf".source = ./.config/btop/btop.conf;
}
