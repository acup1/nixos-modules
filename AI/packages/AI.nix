{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    #lmstudio
    ollama-cuda
  ];
  # services.ollama.enable = true;
  # services.ollama.serve = true;
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;

    user = "ollama";
    group = "ollama";

    home = "/var/lib/ollama";
    modelsDir = "/var/lib/ollama/models";
    environmentVariables.OLLAMA_CONTEXT_LENGTH = "16000";
    # environmentVariables.OLLAMA_NUM_GPU = "0";
  };

  systemd.services.ollama.serviceConfig.DynamicUser =
    lib.mkForce false;
}
