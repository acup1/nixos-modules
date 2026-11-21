{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "android" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
