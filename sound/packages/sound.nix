{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    playerctl
    pipewire
  ];
}
