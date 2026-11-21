{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "fluxcast" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration
    ++ lib.filesystem.listFilesRecursive ./packages;
}
