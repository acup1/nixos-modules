{
  config,
  lib,
  ...
}: let
  # Hermes Agent v0.23.3.
  hermes = builtins.getFlake "github:NousResearch/hermes-agent/caafe5389ae585ef77387a962aee05b1bcf17029";
  cfg = config.services.hermes-web;
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
in {
  imports = [hermes.nixosModules.default];

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

  config = lib.mkIf cfg.enable {
    services.hermes-agent = {
      enable = true;
      backend = {
        mode = "dashboard";
        inherit (cfg) host port;
      };

      # Hermes merges settings recursively in definition order.
      settings = lib.mkBefore (
        {
          model = {
            default = "qwen3.5:9b";
            provider = "custom";
            base_url = "http://${ollamaAuthority}:${toString ollama.port}/v1";
          };
        }
        // lib.optionalAttrs (cfg.publicUrl != null) {
          dashboard.public_url = cfg.publicUrl;
        }
      );
    };

    systemd.services.hermes-backend = lib.mkIf ollama.enable {
      after = ["ollama.service"];
      wants = ["ollama.service"];
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
  };
}
