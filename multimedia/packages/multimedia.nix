{pkgs, ...}: {
  components.multimedia.packages = with pkgs; [
    obs-studio
  ];
}
