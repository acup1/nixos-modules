{lib, ...}: {
  imports = [
      (import ../lib/component-packages.nix "codex" "system")
      (import ../lib/component-packages.nix "AI" "system")
    ] ++ lib.filesystem.listFilesRecursive ./configuration;
}
