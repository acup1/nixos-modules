{config, lib, pkgs, specialArgs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  cfg = config.components.shell;
  flakePath = specialArgs.flakeDir or null;
  username = specialArgs.username or config.home.username;
  systemFlake = lib.escapeShellArg (toString flakePath);
  homeFlake = lib.escapeShellArg "${toString flakePath}#${username}";
  starship = cfg.enabledPackages.starship && lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.starship;
  zshrc = if isDarwin then ./home_packages/zsh/darwin.zsh else ./home_packages/zsh/linux.zsh;
  rebuilds = lib.optionalString (flakePath != null) (
    if isDarwin then ''
      nixrebuild() {
        sudo darwin-rebuild switch --impure --flake ${systemFlake}
      }
      nixhomerebuild() {
        home-manager switch --impure --flake ${homeFlake}
      }
    '' else ''
      alias nixrebuild=${lib.escapeShellArg "sudo nixos-rebuild switch --impure --flake ${systemFlake}"}
      alias nixhomerebuild=${lib.escapeShellArg "home-manager switch --impure --flake ${homeFlake}"}
    ''
  );
in {
  imports = [
    (import ../terminal/profile.nix "shell" "home")
    (import ../lib/package-options.nix "shell" [
      {
        id = "bash";
        available = cfg.standalone;
        definitions.programs.bash = {
          enable = true;
          initExtra = lib.optionalString starship ''
            eval "$(starship init bash)"
          '';
        };
      }
      {
        id = "zsh";
        available = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.zsh;
        definitions.programs.zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          enableCompletion = true;
          initContent = ''
            ${builtins.readFile zshrc}
            ${lib.optionalString starship ''
              eval "$(starship init zsh)"
            ''}
            ${rebuilds}
            alias nixcleanup="sudo nix-collect-garbage -d"
            ${lib.optionalString (flakePath != null) ''
              alias nixfullrebuild="nixrebuild && nixhomerebuild && nixcleanup"
            ''}
          '';
        };
      }
      {id = "starship"; package = pkgs.starship;}
    ])
  ];
}
