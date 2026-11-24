{...}: {
  imports = [(import ../../lib/package-options.nix "bluetooth" [{
    id = "bluez";
    definitions.hardware.bluetooth.enable = true;
  }])];
}
