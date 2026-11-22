{...}: {
  imports = [(import ../../../lib/package-options.nix "common" [
    {
      id = "upower";
      definitions.services.upower = {
        enable = true;
        percentageLow = 20;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "PowerOff";
      };
    }
    {id = "power-profiles-daemon"; definitions.services.power-profiles-daemon.enable = true;}
  ])];
}
