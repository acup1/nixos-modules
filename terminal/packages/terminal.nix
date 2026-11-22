{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "terminal" [
      { id = "alacritty"; package = pkgs.alacritty; }
    ])
  ];
}
