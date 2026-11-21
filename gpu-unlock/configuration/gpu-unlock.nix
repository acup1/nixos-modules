{
  config,
  lib,
  pkgs,
  ...
}: let
  gpu-unlock = config.boot.kernelPackages.callPackage ../package.nix {};
in lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
  boot = {
    extraModulePackages = [gpu-unlock];
    initrd.kernelModules = lib.mkBefore ["gpu_unlock"];
    kernelParams = ["gpu_unlock.targets=all"];
  };

  hardware.firmware = [gpu-unlock];
}
