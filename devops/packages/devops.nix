{pkgs, ...}: let
  inherit (pkgs.stdenv) hostPlatform;
in {
  imports = [(import ../../lib/package-options.nix "devops" (with pkgs; [
    {id = "docker"; package = docker;}
    {id = "docker-compose"; package = docker-compose;}
    {id = "kubectl"; package = kubectl;}
    {id = "kubernetes-helm"; package = kubernetes-helm;}
    {id = "minikube"; package = minikube;}
    {id = "virt-manager"; package = virt-manager; available = hostPlatform.isLinux;}
    {id = "qemu"; package = qemu; available = hostPlatform.isLinux;}
    {id = "terraform"; package = terraform;}
    {id = "terragrunt"; package = terragrunt;}
    {id = "colima"; package = colima; available = hostPlatform.isDarwin;}
  ]))];
}
