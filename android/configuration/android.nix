{...}: {
  imports = [(import ../../lib/package-options.nix "android" [
    {id = "waydroid"; definitions.virtualisation.waydroid.enable = true;}
    {id = "droidcam"; definitions.programs.droidcam.enable = true;}
  ])];
}
