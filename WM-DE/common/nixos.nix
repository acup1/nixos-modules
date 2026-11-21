{lib, ...}: {
  imports =
    [(import ../../lib/component-packages.nix "common" "system")]
    ++ (lib.filesystem.listFilesRecursive ./configuration)
    ++ (lib.filesystem.listFilesRecursive ./packages);
}
