{lib, ...}: let
  noSleep = {
    lockAll = true;
    settings = {
      "org/gnome/desktop/session".idle-delay = lib.gvariant.mkUint32 0;
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
        sleep-inactive-ac-timeout = lib.gvariant.mkInt32 0;
        sleep-inactive-battery-type = "nothing";
        sleep-inactive-battery-timeout = lib.gvariant.mkInt32 0;
      };
    };
  };
in {
  # Sunshine-хост должен оставаться доступным независимо от сессии GNOME.
  systemd.sleep.settings.Sleep = {
    AllowSuspend = false;
    AllowHibernation = false;
    AllowHybridSleep = false;
    AllowSuspendThenHibernate = false;
  };
  services.logind.settings.Login.IdleAction = "ignore";

  # Системная политика действует после system switch, без Home Manager,
  # и запрещает переопределять эти ключи в пользовательской базе dconf.
  programs.dconf.profiles = lib.genAttrs [ "user" "gdm" ] (_: {
    databases = lib.mkAfter [ noSleep ];
  });
}
