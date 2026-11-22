{...}: {
  imports = [(import ../../../lib/package-options.nix "common" [{
    id = "gdm";
    definitions = {
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
    };
  }])];
}
