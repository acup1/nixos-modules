{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "file-viewers" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
