{
  lib,
  pkgs,
  ...
}: let
  ollama = pkgs.ollama-cuda.overrideAttrs (old: {
    version = "0.40.11";

    src = pkgs.fetchFromGitHub {
      owner = "ollama";
      repo = "ollama";
      tag = "v0.40.11";
      hash = "sha256-d6Ob7iWxpzJIp+LTpUitNbzW2LpBwxl8i6lmjgGPofw=";
    };

    vendorHash = "sha256-1mzJrZUHH2ouP6I+LVojHbft7No5AumqKZVq0I/Ubsg=";

    passthru = old.passthru // {
      llamaCppVersion = "b11845";
      llamaCppSrc = pkgs.fetchFromGitHub {
        owner = "ggml-org";
        repo = "llama.cpp";
        tag = "b11845";
        hash = "sha256-YPAncEPG5acFVPrKHOzw0kxoyPiWbVG56iQINxFroq8=";
      };
    };
  });
in {
  services.ollama = {
    enable = true;
    package = ollama;

    host = "127.0.0.1";
    port = 11434;

    user = "ollama";
    group = "ollama";
    home = "/var/lib/ollama";
    modelsDir = "/var/lib/ollama/models";

    environmentVariables.OLLAMA_CONTEXT_LENGTH = "16000";
  };

  systemd.services.ollama.serviceConfig.DynamicUser = lib.mkForce false;
}
