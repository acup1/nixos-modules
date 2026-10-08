{pkgs, ...}: {
  users.groups.plugdev = {};

  services.udev.packages = [pkgs.openfpgaloader];
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", MODE="0660", GROUP="plugdev", TAG+="uaccess"
  '';
}
