{config, lib, pkgs, ...}: let
  fluxcast = pkgs.callPackage ../package.nix {};
in {
  config = lib.mkIf config.components.fluxcast.enabledPackages.fluxcast {
    services.dbus.packages = [fluxcast];

    # The TV connects back to FluxCast over RTSP during a WFD session.
    networking.firewall.allowedTCPPorts = [7236];
  };
}
