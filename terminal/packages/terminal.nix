{pkgs, ...}: {
  components.terminal.packages = with pkgs; [
    alacritty
  ];
}
