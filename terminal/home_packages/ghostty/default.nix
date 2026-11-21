{lib, pkgs, ...}: {
  components.terminal.packages = with pkgs; [
    ghostty
    nerd-fonts.code-new-roman
    nerd-fonts.symbols-only
  ];

  fonts.fontconfig.enable = true;

  xdg.configFile."ghostty" = lib.mkIf (lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.ghostty) {
    source = ./.config/ghostty;
  };
}
