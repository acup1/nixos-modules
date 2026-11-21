{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "nix-serve" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
