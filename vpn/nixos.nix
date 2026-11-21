{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "vpn" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration
    ++ lib.filesystem.listFilesRecursive ./packages;
}
