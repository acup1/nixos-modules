{
  pkgs,
  username,
  ...
}: {
  hardware.uinput.enable = true;
  users.groups.cec = {};
  users.users.${username}.extraGroups = ["cec" "uinput"];

  # Bigscreen starts its libCEC input handler through its own KDED plugin.
  # Grant it access to native CEC devices and Pulse-Eight USB adapters.
  services.udev.extraRules = ''
    SUBSYSTEM=="cec", KERNEL=="cec[0-9]*", GROUP="cec", MODE="0660"
    SUBSYSTEM=="tty", KERNEL=="ttyACM[0-9]*", ATTRS{idVendor}=="2548", ATTRS{idProduct}=="1001|1002", GROUP="cec", MODE="0660"
  '';

  environment.systemPackages = [pkgs.libcec];
}
