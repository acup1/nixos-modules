{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "multimedia" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
