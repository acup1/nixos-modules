{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "moonlight" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
