{pkgs, ...}: {
  imports = [(import ../../lib/package-options.nix "file-viewers" (with pkgs; [
    {id = "nautilus"; package = nautilus;}
    {id = "qimgv"; package = qimgv;}
    {id = "vlc"; package = vlc;}
    {id = "mpv"; package = mpv;}
  ]))];
}
