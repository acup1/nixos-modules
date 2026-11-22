{config, lib, pkgs, ...}: let
  cfg = config.components.wireshark;
  capture = cfg.capture.enable && cfg.capture.users != [];
in {
  imports = [./system.nix];
  config = lib.mkIf (cfg.enabledPackages.wireshark && lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.wireshark) {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
      dumpcap.enable = capture;
    };
    users.groups.wireshark.members = lib.mkIf capture cfg.capture.users;
  };
}
