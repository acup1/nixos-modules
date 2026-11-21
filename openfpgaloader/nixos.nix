{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "openfpgaloader" "system")]
    ++ (lib.filesystem.listFilesRecursive ./configuration)
    ++ (lib.filesystem.listFilesRecursive ./packages);
}

