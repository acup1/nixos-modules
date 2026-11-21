{
  lib,
  pkgs,
  username,
  flakeDir,
  ...
}: let
  flakePath = toString flakeDir;
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    initContent = ''
      ${builtins.readFile ./.zshrc}
      nixrebuild() {
        sudo darwin-rebuild switch --impure --flake ${lib.escapeShellArg flakePath}
      }
      nixhomerebuild() {
        home-manager switch --impure --flake ${lib.escapeShellArg "${flakePath}#${username}"}
      }
      alias nixcleanup="sudo nix-collect-garbage -d"
      alias nixfullrebuild="nixrebuild && nixhomerebuild && nixcleanup"
    '';
  };

  home.packages = [pkgs.starship];
}
