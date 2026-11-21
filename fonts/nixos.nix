{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "fonts" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
