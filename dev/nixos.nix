{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "dev" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
