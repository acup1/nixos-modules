{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "printing" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
