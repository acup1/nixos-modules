{pkgs, ...}: {
  components.hypr.packages = with pkgs; [
    hyprland
    grimblast
  ];
}
