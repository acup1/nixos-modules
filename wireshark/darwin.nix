{config, lib, pkgs, ...}: let
  cfg = config.components.wireshark;
  # Use the ChmodBPF distributed with this exact Wireshark release.
  upstream = "${pkgs.wireshark.src}/packaging/macosx/ChmodBPF/root/Library/Application Support/Wireshark/ChmodBPF/ChmodBPF";
  chmodBPF = pkgs.runCommand "wireshark-chmodbpf" {} ''
    substitute ${lib.escapeShellArg upstream} "$out" \
      --replace-fail "chgrp access_bpf" "chgrp _nix_wireshark"
  '';
in {
  imports = [./system.nix];
  config = lib.mkIf (cfg.enabledPackages.wireshark && cfg.capture.enable && cfg.capture.users != []) {
    launchd.daemons.wireshark-chmodbpf.serviceConfig = {
      ProgramArguments = ["/bin/bash" "${./capture-darwin.sh}" (toString chmodBPF)] ++ cfg.capture.users;
      RunAtLoad = true;
      KeepAlive.SuccessfulExit = false;
    };
  };
}
