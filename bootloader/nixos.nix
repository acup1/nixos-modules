{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "bootloader" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
