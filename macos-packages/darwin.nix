{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "macos-packages" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
