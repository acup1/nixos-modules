{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "codex" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;
}
