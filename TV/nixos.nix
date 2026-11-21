{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "TV" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
