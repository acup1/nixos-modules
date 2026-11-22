{pkgs, ...}: {
  imports = [
    (import ../../../lib/package-options.nix "terminal" [
      {
        id = "ghostty";
        package = pkgs.ghostty;
        definitions.xdg.configFile."ghostty".source = ./.config/ghostty;
      }
      {
        id = "nerd-fonts-code-new-roman";
        package = pkgs.nerd-fonts.code-new-roman;
        definitions.fonts.fontconfig.enable = true;
      }
      {
        id = "nerd-fonts-symbols-only";
        package = pkgs.nerd-fonts.symbols-only;
        definitions.fonts.fontconfig.enable = true;
      }
    ])
  ];
}
