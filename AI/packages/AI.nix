{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    #lmstudio
    ollama-cuda
  ];
  # services.ollama.enable = true;
  # services.ollama.serve = true;
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };
}
