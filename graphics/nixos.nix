{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "graphics" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
