{pkgs, ...}: {
  imports = [(import ../../lib/package-options.nix "graphics" (with pkgs; [
    {id = "freecad-wayland"; package = freecad-wayland;}
    {id = "nvidia-x11"; package = linuxPackages.nvidia_x11;}
    {id = "libglvnd"; package = libglvnd;}
    {id = "coin3d"; package = coin3d;}
    {id = "mesa-demos"; package = mesa-demos;}
    {id = "darktable"; package = darktable;}
  ]))];
}
