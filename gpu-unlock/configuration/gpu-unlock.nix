{
  config,
  lib,
  ...
}: let
  gpu-unlock = config.boot.kernelPackages.callPackage ../package.nix {};
in {
  boot = {
    extraModulePackages = [gpu-unlock];
    initrd.kernelModules = lib.mkBefore ["gpu_unlock"];
    kernelParams = ["gpu_unlock.targets=all"];
  };

  hardware.firmware = [gpu-unlock];
}
