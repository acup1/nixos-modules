{config, lib, pkgs, ...}:
lib.mkIf (
  config.components.openfpgaloader.enabledPackages.openfpgaloader
  && lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.openfpgaloader
) {
  users.groups.plugdev = {};

  services.udev.packages = [pkgs.openfpgaloader];
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", MODE="0660", GROUP="plugdev", TAG+="uaccess"
  '';
}
