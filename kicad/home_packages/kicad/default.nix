{pkgs, ...}: {
  imports = [
    (import ../../../lib/package-options.nix "kicad" [{
      id = "kicad";
      package = pkgs.kicad or null;
      available = pkgs.stdenv.hostPlatform.isLinux;
    }])
  ];
}
