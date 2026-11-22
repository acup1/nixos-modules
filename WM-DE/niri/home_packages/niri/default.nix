{config, lib, ...}: let
  enabled = config.components.niri.enabledPackages;
  dms = config.components.common.enabledPackages.dank-material-shell;
  source = ./.config/niri/config.kdl;
  keepLine = line:
    (enabled.iio-niri || !lib.hasPrefix "spawn-at-startup \"iio-niri\"" line)
    && (dms || !(
      lib.hasPrefix "spawn-at-startup \"dms\"" line || lib.hasPrefix "include \"dms/" line
    ));
in {
  imports = [(import ../../../../lib/package-options.nix "niri" [
    {
      id = "niri";
      definitions.xdg.configFile."niri/config.kdl" =
        if enabled.iio-niri && dms
        then { inherit source; }
        else {
          text = lib.concatStringsSep "\n" (
            lib.filter keepLine (lib.splitString "\n" (builtins.readFile source))
          );
        };
    }
    {id = "iio-niri";}
  ])];
}
