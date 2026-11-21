{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "artcraft" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
