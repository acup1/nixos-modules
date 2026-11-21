{pkgs, ...}: let
  availablePackages = import ../../lib/available-packages.nix pkgs;
in {
  fonts.packages = availablePackages (with pkgs; [
    corefonts
    vista-fonts
    nerd-fonts.code-new-roman
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    migmix
  ]);
}
