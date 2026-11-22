{pkgs, ...}: let
  availablePackages = import ../lib/available-packages.nix pkgs;
  font = id: legacyId: package: {
    inherit id legacyId;
    definitions.fonts.packages = availablePackages [package];
  };
in [
  (font "corefonts" "corefonts" pkgs.corefonts)
  (font "vista-fonts" "vista-fonts" pkgs.vista-fonts)
  (font "nerd-fonts.code-new-roman" "nerd-fonts-code-new-roman" pkgs.nerd-fonts.code-new-roman)
  (font "nerd-fonts.jetbrains-mono" "nerd-fonts-jetbrains-mono" pkgs.nerd-fonts.jetbrains-mono)
  (font "nerd-fonts.symbols-only" "nerd-fonts-symbols-only" pkgs.nerd-fonts.symbols-only)
  (font "noto-fonts-cjk-sans" "noto-fonts-cjk-sans" pkgs.noto-fonts-cjk-sans)
  (font "noto-fonts-cjk-serif" "noto-fonts-cjk-serif" pkgs.noto-fonts-cjk-serif)
  (font "migmix" "migmix" pkgs.migmix)
]
