{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "games" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration
    ++ lib.filesystem.listFilesRecursive ./packages;
}
