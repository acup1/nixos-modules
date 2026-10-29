{
  lib,
  pkgs,
  ...
}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;

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
