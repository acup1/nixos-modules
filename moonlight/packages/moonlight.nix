{pkgs, ...}: {
  components.moonlight.packages = with pkgs; [
    moonlight-qt
  ];
}
