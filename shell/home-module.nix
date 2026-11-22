{config, lib, pkgs, specialArgs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  cfg = config.components.shell;
  supported = import ../lib/package-supported.nix pkgs;
  flakePath = specialArgs.flakeDir or null;
  username = specialArgs.username or config.home.username;
  systemFlake = lib.escapeShellArg (toString flakePath);
  homeFlake = lib.escapeShellArg "${toString flakePath}#${username}";
  rebuildCommand = if isDarwin then "darwin-rebuild" else "nixos-rebuild";
  starship = pkgs.starship or null;
  starshipInit = shell: lib.optionalString (cfg.enabledPackages.starship && supported starship) ''
    eval "$(${lib.getExe starship} init ${shell})"
  '';
  rebuilds = lib.optionalString (flakePath != null) ''
    nixrebuild() {
      NIXOS_BASE_CONFIG="''${NIXOS_BASE_CONFIG:-$HOME/.config/config.nix}" \
        sudo --preserve-env=NIXOS_BASE_CONFIG ${rebuildCommand} switch --impure --flake ${systemFlake}
    }
    nixhomerebuild() {
      home-manager switch --impure --flake ${homeFlake}
    }
    alias nixfullrebuild="nixrebuild && nixhomerebuild && nixcleanup"
  '';
in {
  imports = [
    (import ../terminal/profile.nix "shell" "home")
    (import ../lib/package-options.nix "shell" [
      {
        id = "bash";
        available = cfg.standalone && supported (pkgs.bash or null);
        definitions.programs.bash = {
          enable = true;
          initExtra = starshipInit "bash";
        };
      }
      {
        id = "zsh";
        available = supported (pkgs.zsh or null);
        definitions.programs.zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          enableCompletion = true;
          initContent = ''
            ${builtins.readFile ./home_packages/zsh/.zshrc}
            ${starshipInit "zsh"}
            ${rebuilds}
          '';
        };
      }
      {id = "starship"; package = starship;}
    ])
  ];
}
