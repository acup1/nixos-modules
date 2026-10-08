{...}: {
  # programs.niri sets this to "niri" by default; leave it unset so GDM
  # follows the user's remembered AccountsService session.
  services.displayManager.defaultSession = null;

  services.displayManager.gdm = {
    enable = true;
    # wayland = true;
    autoSuspend = false;
    settings = {
      greeter = {
        IncludeAll = true; # Показывать все учётные записи в списке пользователей
        DisableUserList = false; # Показывать пользователей
      };
    };
  };
}
