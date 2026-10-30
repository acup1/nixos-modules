{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.services.dsh-web;
  home = "/home/${username}";
  nodeHome = "${home}/.local/opt/node-v22.19.0-linux-x64";
  ollamaHost = config.services.ollama.host;
  ollamaAuthority =
    if lib.hasInfix ":" ollamaHost
    then "[${ollamaHost}]"
    else ollamaHost;
  ollamaUrl = "http://${ollamaAuthority}:${toString config.services.ollama.port}";
  ollamaPatchGenerator = pkgs.writeText "dsh-ollama-patch.mjs" ''
    const response = await fetch("${ollamaUrl}/api/tags");
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
        const modelResponse = await fetch("${ollamaUrl}/api/show", {
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
              baseURL: "${ollamaUrl}/v1",
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
      --port ${toString cfg.port}${lib.optionalString (cfg.host != null) " \\\n      --host ${lib.escapeShellArg cfg.host}"}${lib.optionalString (cfg.publicUrl != null) " \\\n      --public-url ${lib.escapeShellArg cfg.publicUrl}"}${lib.concatMapStrings (trustedHost: " \\\n      --trusted-host ${lib.escapeShellArg trustedHost}") cfg.trustedHosts}
  '';
in {
  options.services.dsh-web = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to run the DeepSeek Harness Web UI.";
    };

    host = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Optional concrete local IPv4 or IPv6 address for DSH to bind to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5001;
      description = "TCP port for the DSH Web UI.";
    };

    publicUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Optional public URL advertised by DSH.";
    };

    trustedHosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional authorities accepted by the DSH browser-trust fence.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the configured DSH TCP port in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
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

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
  };
}
