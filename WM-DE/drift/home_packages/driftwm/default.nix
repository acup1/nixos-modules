{pkgs, ...}: let
  autorotate = pkgs.writeShellApplication {
    name = "driftwm-autorotate";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.iio-sensor-proxy
      pkgs.wlr-randr
    ];
    text = builtins.readFile ./autorotate.sh;
  };
in {
  xdg.configFile."driftwm".source = ./.config/driftwm;

  systemd.user.services.driftwm-autorotate = {
    Unit = {
      Description = "Automatic rotation of the built-in display in driftwm";
      # driftwm exports WAYLAND_DISPLAY before reporting readiness to systemd.
      After = [ "driftwm.service" ];
      Requisite = [ "driftwm.service" ];
      PartOf = [ "driftwm.service" "graphical-session.target" ];
      ConditionEnvironment = "XDG_CURRENT_DESKTOP=driftwm";
    };
    Service = {
      ExecStart = "${autorotate}/bin/driftwm-autorotate eDP-1";
      Restart = "always";
      RestartSec = 2;
    };
    Install.WantedBy = [ "driftwm.service" ];
  };
}
