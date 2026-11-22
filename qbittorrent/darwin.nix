{...}: {
  imports = [
    (import ../lib/component-packages.nix "qbittorrent" "system")
    ./packages/qbittorrent.nix
  ];
}
