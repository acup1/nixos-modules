{
  lib,
  pkgs,
  username,
  ...
}: let
  home = "/home/${username}";
  nodeHome = "${home}/.local/opt/node-v22.19.0-linux-x64";
in {
  systemd.services.dsh = {
    description = "DeepSeek Harness Web UI";
    wantedBy = ["multi-user.target"];
    wants = [
      "network-online.target"
      "ollama.service"
    ];
    after = [
      "network-online.target"
      "ollama.service"
    ];

    environment = {
      HOME = home;
      NPM_CONFIG_PREFIX = "${home}/.local";
      PATH = lib.mkForce (lib.concatStringsSep ":" [
        "${nodeHome}/bin"
        "${home}/.local/bin"
        (lib.makeBinPath [
          pkgs.bash
          pkgs.coreutils
          pkgs.git
          pkgs.ollama
        ])
        "/run/current-system/sw/bin"
      ]);
    };

    unitConfig.ConditionPathExists = [
      "${nodeHome}/bin/node"
      "${home}/.local/bin/dsh"
    ];

    serviceConfig = {
      User = username;
      WorkingDirectory = home;
      ExecStart = "${lib.getExe pkgs.ollama} launch dsh --model qwen3.5:9b --yes -- --no-open --port 5001 --public-url http://ru.cupscloud.ru:5001 --trusted-host ru.cupscloud.ru:5001";
      Restart = "on-failure";
      RestartSec = "5s";
      TimeoutStopSec = "30s";
      UMask = "0077";
    };
  };
}
