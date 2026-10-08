{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    hal-hardware-analyzer
  ];
}
