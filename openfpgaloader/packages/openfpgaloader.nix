{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "openfpgaloader" [
      { id = "openfpgaloader"; package = pkgs.openfpgaloader; }
    ])
  ];
}
