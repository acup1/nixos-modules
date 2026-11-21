{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "macos-base" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
