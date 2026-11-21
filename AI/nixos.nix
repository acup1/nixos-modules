{lib, ...}: {
  imports = [
      ../codex/nixos.nix
      (import ../lib/component-packages.nix "AI" "system")
    ] ++ lib.filesystem.listFilesRecursive ./configuration;
}
