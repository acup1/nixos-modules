{
  config,
  lib,
  pkgs,
  username,
  flakeDir,
  ...
}: let
  rebuildCommand =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "darwin-rebuild"
    else "nixos-rebuild";
  systemFlake = lib.escapeShellArg (toString flakeDir);
  homeFlake = lib.escapeShellArg "${toString flakeDir}#${username}";
  enabled = config.components.terminal.enabledPackages;
in {
  imports = [
    (import ../../../lib/package-options.nix "terminal" [
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
              alias nixrebuild=${lib.escapeShellArg "sudo ${rebuildCommand} switch --impure --flake ${systemFlake}"}
              alias nixhomerebuild=${lib.escapeShellArg "home-manager switch --impure --flake ${homeFlake}"}
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
