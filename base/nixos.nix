{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "base" "system")]
    ++ (lib.filesystem.listFilesRecursive ./configuration)
    ++ (lib.filesystem.listFilesRecursive ./packages);
}
