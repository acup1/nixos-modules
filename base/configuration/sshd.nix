{ config, pkgs, inputs, ...}: {
  imports = [(import ../../lib/package-options.nix "base" [{
    id = "openssh";
    definitions = {
      services.openssh.enable = true;
      networking.firewall.allowedTCPPorts = [ 22 ];
      networking.firewall.allowedUDPPorts = [ 22 ];
    };
  }])];
}
