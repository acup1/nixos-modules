{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "messengers" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
