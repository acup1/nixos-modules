{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "sound" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
