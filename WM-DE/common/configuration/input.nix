{...}: {
  imports = [(import ../../../lib/package-options.nix "common" [
    {id = "wacom"; definitions.services.xserver.wacom.enable = true;}
    {id = "opentabletdriver"; definitions.hardware.opentabletdriver.enable = true;}
    {
      id = "xorg-server";
      definitions.services.xserver = {
        enable = true;
        xkb = {
          layout = "us,ru";
          variant = "";
        };
      };
    }
  ])];
}
