{config, pkgs, ...}: {
  imports = [(import ../../lib/package-options.nix "devops" [{
    id = "libvirt";
    available = config.components.devops.enabledPackages.qemu;
    definitions = {
      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
        swtpm.enable = config.components.devops.enabledPackages.swtpm;
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
    };
  } {id = "swtpm";}])];
}
