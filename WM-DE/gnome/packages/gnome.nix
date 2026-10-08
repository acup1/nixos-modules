{pkgs, ...}: {
  environment.systemPackages = with pkgs; [ gnomeExtensions.screen-rotate ];
}
