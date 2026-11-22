{pkgs, ...}: let
  availablePackages = import ../../lib/available-packages.nix pkgs;
  font = id: package: {
    inherit id;
    definitions.fonts.packages = availablePackages [package];
  };
in {
  imports = [(import ../../lib/package-options.nix "fonts" (with pkgs; [
    (font "corefonts" corefonts)
    (font "vista-fonts" vista-fonts)
    (font "nerd-fonts.code-new-roman" nerd-fonts.code-new-roman)
    (font "nerd-fonts.jetbrains-mono" nerd-fonts.jetbrains-mono)
    (font "nerd-fonts.symbols-only" nerd-fonts.symbols-only)
    (font "noto-fonts-cjk-sans" noto-fonts-cjk-sans)
    (font "noto-fonts-cjk-serif" noto-fonts-cjk-serif)
    (font "migmix" migmix)
  ]))];
}
