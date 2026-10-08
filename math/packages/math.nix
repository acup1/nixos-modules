{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qalculate-gtk
    (octaveFull.withPackages (p: with p; [signal symbolic]))
    gnuradio
  ];
}
