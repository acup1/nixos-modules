{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "doc-redactors" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
