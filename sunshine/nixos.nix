{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "sunshine" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
