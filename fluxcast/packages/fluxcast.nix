{pkgs, ...}: {
  components.fluxcast.packages = [
    (pkgs.callPackage ../package.nix {})
  ];
}
