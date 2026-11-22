{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "gpu-unlock" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
