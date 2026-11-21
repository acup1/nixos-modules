{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "udev-rules" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
