{pkgs, ...}: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  # virtualisation = {
  #   libvirtd = {
  #     enable = true;
  #     package = with pkgs.stable; libvirt;
  #     qemu = {
  #       package = with pkgs.stable; qemu;
  #       swtpm = {
  #         enable = false;
  #         package = with pkgs.stable; swtpm;
  #       };
  #     };
  #   };
  #   spiceUSBRedirection.enable = true;
  # };
  # users.users.${username}.extraGroups = [ "libvirtd" ];
  # services.spice-vdagentd.enable = true;
  # programs.virt-manager.enable = true;
}
