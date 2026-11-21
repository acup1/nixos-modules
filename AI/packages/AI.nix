{ pkgs, ... }: {
  components.AI.packages = with pkgs;
    [
      #lmstudio
      # ollama
    ];
  # services.ollama.enable = true;
  # services.ollama.serve = true;
}
