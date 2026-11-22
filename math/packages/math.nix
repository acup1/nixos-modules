{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "math" [
      { id = "qalculate-gtk"; package = pkgs.qalculate-gtk; }
      { id = "octave"; package = (pkgs.octaveFull.withPackages (p: [p.signal p.symbolic])); }
      { id = "gnuradio"; package = pkgs.gnuradio; }
    ])
  ];
}
