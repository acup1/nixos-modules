{ pkgs, ...}: {
  imports = [(import ../../../lib/package-options.nix "common" [{
    id = "iio-sensor-proxy";
    definitions = {
      hardware.sensor.iio.enable = true;
      components.common.packages = with pkgs; [ iio-sensor-proxy ];
      services.dbus.enable = true;
    };
  }])];
}
