{lib, pkgs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) system;
in {
  components.printing.packages = with pkgs;
    # The upstream archive only ships x86 printer drivers.
    lib.optional (builtins.elem system ["i686-linux" "x86_64-linux"]) fxlinuxprint
    ++ [cups];
}
