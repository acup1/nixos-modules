{lib, pkgs, ...}: let
  inherit (pkgs.stdenv) hostPlatform;
in {
  imports = [
    (import ../../lib/package-options.nix "macos-packages" [
      { id = "corefonts"; available = lib.meta.availableOn hostPlatform pkgs.corefonts; definitions.fonts.packages = [pkgs.corefonts]; }
      { id = "vista-fonts"; available = lib.meta.availableOn hostPlatform pkgs.vista-fonts; definitions.fonts.packages = [pkgs.vista-fonts]; }
      { id = "nerd-fonts-code-new-roman"; available = lib.meta.availableOn hostPlatform pkgs.nerd-fonts.code-new-roman; definitions.fonts.packages = [pkgs.nerd-fonts.code-new-roman]; }
      { id = "nerd-fonts-jetbrains-mono"; available = lib.meta.availableOn hostPlatform pkgs.nerd-fonts.jetbrains-mono; definitions.fonts.packages = [pkgs.nerd-fonts.jetbrains-mono]; }
      { id = "nerd-fonts-symbols-only"; available = lib.meta.availableOn hostPlatform pkgs.nerd-fonts.symbols-only; definitions.fonts.packages = [pkgs.nerd-fonts.symbols-only]; }
      { id = "noto-fonts-cjk-sans"; available = lib.meta.availableOn hostPlatform pkgs.noto-fonts-cjk-sans; definitions.fonts.packages = [pkgs.noto-fonts-cjk-sans]; }
      { id = "noto-fonts-cjk-serif"; available = lib.meta.availableOn hostPlatform pkgs.noto-fonts-cjk-serif; definitions.fonts.packages = [pkgs.noto-fonts-cjk-serif]; }
      { id = "migmix"; available = lib.meta.availableOn hostPlatform pkgs.migmix; definitions.fonts.packages = [pkgs.migmix]; }
    ])
  ];
}
