{pkgs, ...}: {
  components.hardware.packages = with pkgs; [
    hal-hardware-analyzer
  ];
}
