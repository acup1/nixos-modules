{
  lib,
  pkgs,
  username,
  ...
}: let
  home = "/home/${username}";
  nodeHome = "${home}/.local/opt/node-v22.19.0-linux-x64";
  ollamaPatch = pkgs.writeText "dsh-ollama.cordis.yml" ''
    - id: agent-default-model
      config:
        provider: ollama
        model: qwen3.5:9b
    - id: llm-pi-ai
      config:
        providers:
          ollama:
            displayName: Ollama
            apiKeyEnv: OLLAMA_LAUNCH_DSH_API_KEY
            api: openai-completions
            baseURL: http://127.0.0.1:11434/v1
            models:
              - id: qwen3.5:9b
                name: qwen3.5:9b
                contextWindow: 262144
                input:
                  - text
                  - image
              - id: rafw007/qwen35-claude-coder:9b
                name: rafw007/qwen35-claude-coder:9b
                contextWindow: 262144
                input:
                  - text
                  - image
              - id: brnpistone/Qwen3-4B-AgentCoder-q6-k:latest
                name: brnpistone/Qwen3-4B-AgentCoder-q6-k:latest
                contextWindow: 262144
                input:
                  - text
              - id: qwen3:14b
                name: qwen3:14b
                contextWindow: 40960
                input:
                  - text
  '';
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
      OLLAMA_LAUNCH_DSH_API_KEY = "ollama";
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
      ExecStart = "${home}/.local/bin/dsh web --patch ${ollamaPatch} --no-open --port 5001 --public-url http://ru.cupscloud.ru:5001 --trusted-host ru.cupscloud.ru:5001";
      Restart = "on-failure";
      RestartSec = "5s";
      TimeoutStopSec = "30s";
      UMask = "0077";
    };
  };
}
