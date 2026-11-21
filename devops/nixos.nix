{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "devops" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration
    ++ lib.filesystem.listFilesRecursive ./packages;
}
