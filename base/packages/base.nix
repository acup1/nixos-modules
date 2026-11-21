{pkgs, ...}: {
  components.base.packages = with pkgs; [
    git
    wget
    unzip
    p7zip
    fzf
    bat
    neovim
    fastfetch
    usbutils
    zsh
  ];
}
