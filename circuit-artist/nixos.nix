{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "circuit-artist" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
