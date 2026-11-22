{pkgs, ...}: {
  imports = [(import ../../../lib/package-options.nix "hypr" (with pkgs; [
    {id = "hyprland"; package = hyprland;}
    {id = "grimblast"; package = grimblast;}
  ]))];
}
