{
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
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    initContent = ''
      ${builtins.readFile ./.zshrc}
      alias nixrebuild=${lib.escapeShellArg "sudo ${rebuildCommand} switch --impure --flake ${systemFlake}"}
      alias nixhomerebuild=${lib.escapeShellArg "home-manager switch --impure --flake ${homeFlake}"}
      alias nixcleanup="sudo nix-collect-garbage -d"
      alias nixfullrebuild="nixrebuild && nixhomerebuild && nixcleanup"
      # ${pkgs.pokemon-colorscripts}/bin/pokemon-colorscripts -r -b
    '';
  };

  home.packages = with pkgs; [
    starship
    # pokemon-colorscripts
  ];
}
