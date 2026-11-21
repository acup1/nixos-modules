{pkgs, ...}: {
  components.qbittorrent.packages = with pkgs; [ qbittorrent ];
}
