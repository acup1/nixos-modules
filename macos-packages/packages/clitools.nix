{pkgs, ...}: {
  components.macos-packages.packages = with pkgs; [
    wget
    curl
    watch
    unzip
    fzf
    zsh
    git
    sshfs

    bat
    zellij

    fastfetch
    cmatrix
    pipes-rs

    comma

    yq
  ];
}
