{pkgs, ...}: {
  imports = [(import ../../../lib/package-options.nix "gnome" (with pkgs; [
    {id = "screen-rotate"; package = gnomeExtensions.screen-rotate;}
  ]))];
}
