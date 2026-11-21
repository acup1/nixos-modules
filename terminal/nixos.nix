{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "terminal" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
