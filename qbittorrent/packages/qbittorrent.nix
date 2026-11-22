{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "qbittorrent" [
      { id = "qbittorrent"; package = pkgs.qbittorrent; }
    ])
  ];
}
