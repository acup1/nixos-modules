{pkgs, ...}: {
  components.niri.packages = with pkgs; [ iio-niri ];
}
