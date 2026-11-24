{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "bluetooth" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
