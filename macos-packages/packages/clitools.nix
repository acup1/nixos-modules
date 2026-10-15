{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wget
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
