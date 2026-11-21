{pkgs, ...}: {
  components.math.packages = with pkgs; [
    qalculate-gtk
    (octaveFull.withPackages (p: with p; [signal symbolic]))
    gnuradio
  ];
}
