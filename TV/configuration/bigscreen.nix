{
  pkgs,
  username,
  ...
}: {
  imports = [(import ../../lib/package-options.nix "TV" (with pkgs.kdePackages; [
    {
      id = "plasma-bigscreen";
      package = plasma-bigscreen;
      definitions = {
        hardware.graphics.enable = true;

        services.desktopManager.plasma6 = {
          enable = true;
          enableQt5Integration = false;
        };

        services.displayManager = {
          sddm.enable = true;
          sddm.wayland.enable = true;
          sessionPackages = [pkgs.kdePackages.plasma-bigscreen];
          defaultSession = "plasma-bigscreen-wayland";
          autoLogin = {
            enable = true;
            user = username;
          };
        };

        programs.kde-pim.enable = false;

        # Bigscreen 6.8's splash times out during login. Start the TV shell directly.
        systemd.user.services.plasma-ksplash = {
          overrideStrategy = "asDropin";
          unitConfig.ConditionEnvironment = "!PLASMA_PLATFORM=mediacenter";
        };

        environment.plasma6.excludePackages = with pkgs.kdePackages; [
          ark
          elisa
          gwenview
          kate
          khelpcenter
          krdp
          okular
          plasma-browser-integration
          plasma-workspace-wallpapers
          spectacle
        ];
      };
    }
    # The homescreen dynamically imports these QML plugins from the session.
    {id = "plasma-nano"; package = plasma-nano;}
    {id = "kdeconnect-kde"; package = kdeconnect-kde;}
    {id = "kirigami-addons"; package = kirigami-addons;}
    {id = "kitemmodels"; package = kitemmodels;}
    {id = "layer-shell-qt"; package = layer-shell-qt;}
  ]))];
}
