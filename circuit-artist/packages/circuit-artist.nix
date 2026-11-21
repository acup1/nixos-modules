{pkgs, ...}: {
  components.circuit-artist.packages = [
    (pkgs.callPackage ../package.nix {})
  ];
}
