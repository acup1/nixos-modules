{pkgs, lib, ...}: let
  artcraftPackages = pkgs.callPackage ../packages.nix {};
in {
  environment.systemPackages = lib.filter lib.isDerivation (builtins.attrValues artcraftPackages);
}
