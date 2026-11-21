{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "AI" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
