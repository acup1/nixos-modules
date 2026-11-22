{
  config,
  lib,
  pkgs,
  username,
  flakeDir,
  ...
}: let
  flakePath = toString flakeDir;
  enabled = config.components.macos-home.enabledPackages;
in {
  imports = [
    (import ../../../lib/package-options.nix "macos-home" [
      {
        id = "zsh";
        available = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.zsh;
        definitions = {
          programs.zsh = {
            enable = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            enableCompletion = true;

            initContent = ''
              ${builtins.readFile ./.zshrc}
              ${lib.optionalString (enabled.starship && lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.starship) ''
                eval "$(starship init zsh)"
              ''}
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
        };
      }
      { id = "starship"; package = pkgs.starship; }
    ])
  ];
}
