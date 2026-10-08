{pkgs, ...}: let
  # customGo = pkgs.go.overrideAttrs (old: {
  #   preConfigure = (old.preConfigure or "") + ''
  #     export CGO_ENABLED=0
  #   '';
  # });
  # customWinboat = pkgs.winboat.override {
  #   buildGoModule = args: pkgs.buildGoModule (args // { go = customGo; });
  # };
in {
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    winboat
    kubectl

    virt-manager
    qemu

    terraform
    terragrunt
  ];
}
