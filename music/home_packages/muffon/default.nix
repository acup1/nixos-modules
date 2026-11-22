{pkgs, ...}: {
  imports = [
    (import ../../../lib/package-options.nix "music" [
      { id = "muffon"; package = pkgs.muffon; }
    ])
  ];
}
