{pkgs, ...}: {
  imports = [(import ../../lib/package-options.nix "browsers" (with pkgs; [
    {id = "google-chrome"; package = google-chrome;}
    {id = "tor-browser"; package = tor-browser;}
  ]))];
}
