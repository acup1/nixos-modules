{pkgs, ...}: {
  components.common.packages = with pkgs; [ networkmanagerapplet ];
}
