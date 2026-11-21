{ pkgs, ... }: {
  hardware.sensor.iio.enable = true;
  components.common.packages = with pkgs; [ iio-sensor-proxy ];
  services.dbus.enable = true;
}
