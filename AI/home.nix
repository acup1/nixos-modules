{lib, pkgs, specialArgs, ...}: let
  system = specialArgs.system or (specialArgs.pkgs.stdenv.hostPlatform.system or builtins.currentSystem);
  platform = pkgs.stdenv.hostPlatform;
  ollama = pkgs.ollama or null;
in {
  imports = [
    (import ../lib/component-packages.nix "AI" "home")
    (import ../lib/package-options.nix "AI" [
      {id = "codex"; package = pkgs.codex or null;}
      {id = "hermes-agent";}
      {
        id = "ollama";
        available = ollama != null && lib.meta.availableOn platform ollama && !(ollama.meta.broken or false);
        definitions = {
          services.ollama = {
            enable = true;
            package = ollama;
            environmentVariables.OLLAMA_CONTEXT_LENGTH = lib.mkDefault "64000";
          };
          launchd.agents.ollama.config.RunAtLoad = lib.mkDefault true;
        };
      }
    ])
  ] ++ lib.optional (system == "aarch64-darwin") ./darwin-hermes.nix;
}
