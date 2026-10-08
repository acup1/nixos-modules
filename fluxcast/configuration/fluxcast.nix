{pkgs, ...}: let
  fluxcast = pkgs.callPackage ../package.nix {};
in {
  services.dbus.packages = [fluxcast];

  # The TV connects back to FluxCast over RTSP during a WFD session.
  networking.firewall.allowedTCPPorts = [7236];
}
