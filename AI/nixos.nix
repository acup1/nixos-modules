{lib, ...}: {
  imports = [../codex/nixos.nix] ++ lib.filesystem.listFilesRecursive ./configuration;
}
