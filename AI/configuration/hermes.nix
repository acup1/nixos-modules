{
  config,
  lib,
  pkgs,
  ...
}: let
  # Hermes Agent v0.23.3.
  hermes = builtins.getFlake "github:NousResearch/hermes-agent/caafe5389ae585ef77387a962aee05b1bcf17029";
  cfg = config.services.hermes-web;
  enabled = config.components.AI.enabledPackages;
  ollama = config.services.ollama;
  ollamaHost =
    if ollama.host == "0.0.0.0"
    then "127.0.0.1"
    else if ollama.host == "::"
    then "::1"
    else ollama.host;
  ollamaAuthority =
    if lib.hasInfix ":" ollamaHost
    then "[${ollamaHost}]"
    else ollamaHost;
  ollamaUrl = "http://${ollamaAuthority}:${toString ollama.port}/v1";
in {
  imports = [
    hermes.nixosModules.default
    (import ../../lib/package-options.nix "AI" [
      {id = "hermes-agent";}
      {id = "codex";}
    ])
  ];

  options.services.hermes-web = {
    enable = lib.mkEnableOption "the Hermes Agent web dashboard" // {default = true;};

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address for the Hermes dashboard to listen on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5001;
      description = "TCP port for the Hermes dashboard.";
    };

    publicUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Canonical browser URL for the Hermes dashboard behind a reverse proxy.";
    };

    openFirewall = lib.mkEnableOption "opening the Hermes dashboard TCP port in the firewall";
  };

  config = lib.mkMerge [
    (lib.mkIf (!enabled.codex) { components.codex.enabledPackages.codex = lib.mkDefault false; })
    (lib.mkIf (cfg.enable && enabled.hermes-agent) {
    components.AI.packages = [config.services.hermes-agent.package];

    services.hermes-agent = {
      enable = true;
      extraPackages = lib.optional enabled.codex pkgs.codex;
      # Reclaim this profile if the dashboard started a detached gateway.
      extraArgs = lib.mkBefore ["run" "--replace"];
      backend = {
        mode = "dashboard";
        inherit (cfg) host port;
      };

      # Hermes merges settings recursively in definition order.
      settings = lib.mkBefore (
        {
          model = lib.optionalAttrs ollama.enable {
            default = "qwen3.5:9b";
            provider = "ollama";
            base_url = ollamaUrl;
          } // lib.optionalAttrs enabled.codex { codex_bin = lib.getExe' pkgs.codex "codex"; };
        }
        // lib.optionalAttrs ollama.enable {
          providers.ollama = {
            name = "Ollama";
            base_url = ollamaUrl;
            discover_models = true;
          };
        }
        // lib.optionalAttrs (cfg.publicUrl != null) {
          dashboard.public_url = cfg.publicUrl;
        }
      );
    };

    systemd.services.hermes-backend = {
      after = ["hermes-agent.service"] ++ lib.optional ollama.enable "ollama.service";
      wants = lib.optional ollama.enable "ollama.service";
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
    })
  ];
}
