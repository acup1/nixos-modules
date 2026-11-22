{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "k3s" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
