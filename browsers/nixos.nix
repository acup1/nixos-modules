{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "browsers" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
