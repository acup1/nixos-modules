{lib, pkgs, ...}: {
  components.devops.packages = with pkgs;
    [docker docker-compose]
    ++ lib.optional stdenv.hostPlatform.isLinux winboat
    ++ [kubectl]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [kubernetes-helm minikube]
    ++ lib.optionals stdenv.hostPlatform.isLinux [virt-manager qemu]
    ++ [terraform terragrunt]
    ++ lib.optional stdenv.hostPlatform.isDarwin colima;
}
