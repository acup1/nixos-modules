{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "hardware" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
