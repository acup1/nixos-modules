{config, lib, pkgs, ...}: let
  hermes = import ./hermes-source.nix;
  enabled = config.components.AI.enabledPackages;
  codex = pkgs.codex or null;
  haveCodex = enabled.codex && codex != null && lib.meta.availableOn pkgs.stdenv.hostPlatform codex;
  ollama = config.services.ollama;
  ollamaHost =
    if ollama.host == "0.0.0.0" then "127.0.0.1"
    else if builtins.elem ollama.host ["::" "[::]"] then "[::1]"
    else if lib.hasInfix ":" ollama.host && !lib.hasPrefix "[" ollama.host then "[${ollama.host}]"
    else ollama.host;
  ollamaUrl = "http://${ollamaHost}:${toString ollama.port}/v1";
in {
  imports = [hermes.homeManagerModules.default];

  config = lib.mkIf enabled.hermes-agent {
    programs.hermes-agent.enable = true;
    services.hermes-agent = {
      enable = true;
      backend = {
        mode = lib.mkDefault "dashboard";
        host = lib.mkDefault "127.0.0.1";
        port = lib.mkDefault 5001;
      };
      settings = lib.mkBefore ({
        model = lib.optionalAttrs ollama.enable {
          default = "qwen3.5:9b";
          provider = "ollama";
          base_url = ollamaUrl;
        } // lib.optionalAttrs haveCodex {
          codex_bin = lib.getExe' codex "codex";
        };
      } // lib.optionalAttrs ollama.enable {
        providers.ollama = {
          name = "Ollama";
          base_url = ollamaUrl;
          discover_models = true;
        };
      });
    };
  };
}
