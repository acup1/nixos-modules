{
  pkgs,
  username,
  ...
}: let
  inherit (pkgs.kdePackages) plasma-bigscreen plasma-nano;
in {
  hardware.graphics.enable = true;

  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = false;
  };

  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    sessionPackages = [plasma-bigscreen];
    defaultSession = "plasma-bigscreen-wayland";
    autoLogin = {
      enable = true;
      user = username;
    };
  };

  programs.kde-pim.enable = false;

  environment = {
    systemPackages = [plasma-bigscreen plasma-nano];
    plasma6.excludePackages = with pkgs.kdePackages; [
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
