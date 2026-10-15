{lib, pkgs, ...}: {
  environment.systemPackages =
    (with pkgs; [
      docker
      docker-compose
      kubectl
      kubernetes-helm
      minikube

      terraform
      terragrunt
    ])
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin (with pkgs; [
      colima
    ])
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (with pkgs; [
      virt-manager
      qemu
    ]);
}
