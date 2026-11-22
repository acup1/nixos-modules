{pkgs, ...}: {
  imports = [(import ../../lib/package-options.nix "circuit-artist" (with pkgs; [
    {id = "circuit-artist"; package = (pkgs.callPackage ../package.nix {});}
  ]))];
}
