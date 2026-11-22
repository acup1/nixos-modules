{
  config,
  lib,
  pkgs,
  ...
}: let
  gpu-unlock = config.boot.kernelPackages.callPackage ../package.nix {};
in {
  imports = [(import ../../lib/package-options.nix "gpu-unlock" [{
    id = "gpu-unlock";
    available = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
    definitions = {
      boot = {
        extraModulePackages = [gpu-unlock];
        initrd.kernelModules = lib.mkBefore ["gpu_unlock"];
        kernelParams = ["gpu_unlock.targets=all"];
      };

      hardware.firmware = [gpu-unlock];
    };
  }])];
}
