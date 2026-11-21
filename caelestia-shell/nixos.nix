{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "caelestia-shell" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
