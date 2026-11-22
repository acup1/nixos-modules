{pkgs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
in {
  imports = [
    (import ../../../lib/package-options.nix "music" [
      {
        id = "muffon";
        default = isLinux;
        package = if isDarwin then pkgs.callPackage ./darwin-package.nix {} else pkgs.muffon;
      }
    ])
  ];
}
