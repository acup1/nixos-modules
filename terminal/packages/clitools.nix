{pkgs, ...}: {
  components.terminal.packages = with pkgs; [
    comma

    linuxKernel.packages.linux_zen.cpupower

    sshfs

    cmatrix
    pipes-rs
  ];
}
