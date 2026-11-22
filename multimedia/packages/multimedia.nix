{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "multimedia" [
      { id = "obs-studio"; package = pkgs.obs-studio; }
    ])
  ];
}
