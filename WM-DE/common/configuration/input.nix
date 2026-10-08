{...}: {
  services.xserver.wacom.enable = true; # или убедись что libinput активен
  hardware.opentabletdriver.enable = true; # альтернатива — OpenTabletDriver

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us,ru";
      variant = "";
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
