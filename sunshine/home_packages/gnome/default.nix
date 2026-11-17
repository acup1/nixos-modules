{lib, ...}: {
  dconf.settings = {
    "org/gnome/desktop/session".idle-delay = lib.hm.gvariant.mkUint32 0;
    "org/gnome/desktop/screensaver".lock-enabled = false;
    "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type = "nothing";
  };
}
