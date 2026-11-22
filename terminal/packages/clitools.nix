{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "terminal" [
      { id = "comma"; package = pkgs.comma; }
      { id = "cpupower"; package = pkgs.linuxKernel.packages.linux_zen.cpupower; }
      { id = "sshfs"; package = pkgs.sshfs; }
      { id = "cmatrix"; package = pkgs.cmatrix; }
      { id = "pipes-rs"; package = pkgs.pipes-rs; }
    ])
  ];
}
