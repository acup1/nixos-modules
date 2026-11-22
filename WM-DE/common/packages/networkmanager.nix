{pkgs, ...}: {
  imports = [(import ../../../lib/package-options.nix "common" (with pkgs; [
    {id = "networkmanagerapplet"; package = networkmanagerapplet;}
  ]))];
}
