{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "qbittorrent" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
