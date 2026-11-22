{pkgs, lib, ...}: let
  packages = import ../packages.nix {inherit pkgs;};
in {
  imports = [(import ../../lib/package-options.nix "artcraft" (lib.mapAttrsToList (id: package: {
    inherit id package;
    available = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
  }) packages))];
}
