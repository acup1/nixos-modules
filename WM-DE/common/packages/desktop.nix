{pkgs, ...}: {
  imports = [(import ../../../lib/package-options.nix "common" (with pkgs; [
    {id = "cliphist"; package = cliphist;}
    {id = "fuzzel"; package = fuzzel;}
    {id = "wl-clipboard-x11"; package = wl-clipboard-x11;}
    {id = "xclip"; package = xclip;}
    {id = "brightnessctl"; package = brightnessctl;}
    {id = "xwayland-satellite"; package = xwayland-satellite;}
    {id = "slurp"; package = slurp;}
    {id = "grim"; package = grim;}
    {id = "wl-clipboard"; package = wl-clipboard;}
  ]))];
}
