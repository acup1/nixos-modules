{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "hardware" [
      { id = "hal-hardware-analyzer"; package = pkgs.hal-hardware-analyzer; }
    ])
  ];
}
