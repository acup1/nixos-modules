{pkgs, ...}: {
  imports = [(import ../../lib/package-options.nix "codex" (with pkgs; [
    {id = "codex"; package = codex;}
  ]))];
}
