{config, lib, options, pkgs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  cfg = config.components.terminal-emulators;
  decorationOption = options.components.terminal-emulators.showWindowDecorations;
  decorationOverride = decorationOption.highestPrio < (lib.mkOptionDefault false).priority;
  ghostty = if isDarwin then pkgs.ghostty-bin or null else pkgs.ghostty or null;
  bundledConfig =
    if isDarwin
    then ./home_packages/ghostty/darwin
    else ./home_packages/ghostty/linux;
  configLines = lib.splitString "\n" (builtins.readFile (bundledConfig + "/config"));
  ghosttyConfig = pkgs.writeText "ghostty-config" ''
    ${lib.concatStringsSep "\n" (lib.filter (line: !(lib.hasPrefix "window-decoration" line)) configLines)}
    window-decoration = ${lib.boolToString cfg.showWindowDecorations}
  '';
  ghosttyFiles = pkgs.runCommand "ghostty-config-files" {} ''
    mkdir -p "$out"
    cp -r ${bundledConfig}/. "$out"
    rm "$out/config"
    cp ${ghosttyConfig} "$out/config"
  '';
  font = id: package: {
    inherit id package;
    available = isLinux;
    definitions.fonts.fontconfig.enable = true;
  };
in {
  imports = [
    (import ../terminal/profile.nix "terminal-emulators" "home")
    (import ../lib/package-options.nix "terminal-emulators" [
      {
        id = "alacritty";
        available = decorationOverride;
        definitions.xdg.configFile."alacritty/alacritty.toml".text = ''
          [window]
          decorations = "${if cfg.showWindowDecorations then "Full" else "None"}"
        '';
      }
      {
        id = "ghostty";
        package = ghostty;
        definitions.xdg.configFile.ghostty.source =
          if cfg.showWindowDecorations == isDarwin then bundledConfig else ghosttyFiles;
      }
      (font "nerd-fonts-code-new-roman" pkgs.nerd-fonts.code-new-roman)
      (font "nerd-fonts-symbols-only" pkgs.nerd-fonts.symbols-only)
    ])
  ];

  options.components.terminal-emulators.showWindowDecorations = lib.mkOption {
    type = lib.types.bool;
    default = isDarwin;
    defaultText = lib.literalExpression "pkgs.stdenv.hostPlatform.isDarwin";
    description = "Show window decorations in Ghostty and Alacritty.";
  };
}
