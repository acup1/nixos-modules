{pkgs, ...}: {
  imports = [(import ../../lib/package-options.nix "fluxcast" (with pkgs; [
    {id = "fluxcast"; package = (pkgs.callPackage ../package.nix {});}
  ]))];
}
