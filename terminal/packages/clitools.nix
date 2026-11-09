{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    comma
    curl
    watch

    linuxKernel.packages.linux_zen.cpupower

    sshfs

    cmatrix
    pipes-rs
  ];
}
