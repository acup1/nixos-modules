{pkgs, ...}: {
  environment.systemPackages = with pkgs; [ iio-niri ];
}
