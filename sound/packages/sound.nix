{pkgs, ...}: {
  components.sound.packages = with pkgs; [
    playerctl
    pipewire
  ];
}
