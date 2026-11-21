{pkgs, lib, ...}: let
  artcraftPackages = pkgs.callPackage ../packages.nix {};
in {
  components.artcraft.packages = lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux")
    (lib.filter lib.isDerivation (builtins.attrValues artcraftPackages));
}
