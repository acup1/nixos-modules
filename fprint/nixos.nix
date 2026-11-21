{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "fprint" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
