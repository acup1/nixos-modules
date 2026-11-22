{pkgs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) system;
in {
  imports = [
    (import ../../lib/package-options.nix "printing" [
      {
        id = "fxlinuxprint";
        # The upstream archive only ships x86 printer drivers.
        available = builtins.elem system ["i686-linux" "x86_64-linux"];
        package = pkgs.fxlinuxprint;
      }
      { id = "cups"; package = pkgs.cups; }
    ])
  ];
}
