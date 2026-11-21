{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "math" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
