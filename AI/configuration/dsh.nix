{
  lib,
  pkgs,
  username,
  ...
}: let
  home = "/home/${username}";
  nodeHome = "${home}/.local/opt/node-v22.19.0-linux-x64";
  ollamaPatchGenerator = pkgs.writeText "dsh-ollama-patch.mjs" ''
    const response = await fetch("http://127.0.0.1:11434/api/tags");
    if (!response.ok) {
      throw new Error(`Ollama returned HTTP ''${response.status}`);
    }

    const catalog = await response.json();
    const names = catalog.models
      ?.map((model) => model.name)
      .filter((name) => typeof name === "string" && name.length > 0);

    if (!names?.length) {
      throw new Error("Ollama has no installed models");
    }

    async function describeModel(name) {
      const model = { id: name, name, input: ["text"] };

      try {
        const modelResponse = await fetch("http://127.0.0.1:11434/api/show", {
          method: "POST",
          headers: { "content-type": "application/json" },
          body: JSON.stringify({ model: name }),
        });
        if (!modelResponse.ok) {
          throw new Error("Ollama returned HTTP " + modelResponse.status);
        }

        const description = await modelResponse.json();
        if (description.capabilities?.includes("vision")) {
          model.input.push("image");
        }

        const contextWindow = Object.entries(description.model_info ?? {})
          .find(([key, value]) => key.endsWith(".context_length") && Number.isFinite(value))
          ?.[1];
        if (contextWindow > 0) {
          model.contextWindow = contextWindow;
        }
      } catch (error) {
        console.error("Cannot read Ollama metadata for " + name + ": " + error);
      }

      return model;
    }

    const models = await Promise.all(names.map(describeModel));
    const preferredModel = "qwen3.5:9b";
    const defaultModel = names.includes(preferredModel) ? preferredModel : names[0];
    const patch = [
      {
        id: "agent-default-model",
        config: {
          provider: "ollama",
          model: defaultModel,
        },
      },
      {
        id: "llm-pi-ai",
        config: {
          providers: {
            ollama: {
              displayName: "Ollama",
              apiKeyEnv: "OLLAMA_LAUNCH_DSH_API_KEY",
              api: "openai-completions",
              baseURL: "http://127.0.0.1:11434/v1",
              defaultContextWindow: 262144,
              defaultMaxTokens: 32768,
              models,
            },
          },
        },
      },
    ];

    process.stdout.write(JSON.stringify(patch, null, 2));
  '';
  dshStart = pkgs.writeShellScript "dsh-start" ''
    set -euo pipefail

    patch_path="''${RUNTIME_DIRECTORY}/ollama.cordis.json"
    "${nodeHome}/bin/node" "${ollamaPatchGenerator}" > "$patch_path"
    exec "${home}/.local/bin/dsh" web \
      --patch "$patch_path" \
      --no-open \
      --port 5001 \
      --public-url http://ru.cupscloud.ru:5001 \
      --trusted-host ru.cupscloud.ru:5001
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
      ExecStart = dshStart;
      RuntimeDirectory = "dsh";
      RuntimeDirectoryMode = "0700";
      Restart = "on-failure";
      RestartSec = "5s";
      TimeoutStopSec = "30s";
      UMask = "0077";
    };
  };
}
