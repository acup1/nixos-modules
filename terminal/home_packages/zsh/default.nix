{
  pkgs,
  username,
  flakeDir,
  ...
}: let
  rebuildCommand =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "darwin-rebuild"
    else "nixos-rebuild";
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    initContent = ''
      ${builtins.readFile ./.zshrc}
      alias nixrebuild="sudo ${rebuildCommand} switch --impure --flake ${flakeDir}"
      alias nixhomerebuild="home-manager switch --impure --flake ${flakeDir}#${username}"
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
