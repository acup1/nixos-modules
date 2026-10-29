{
  fetchFromGitHub,
  fetchurl,
  kernel,
  kernelModuleMakeFlags,
  lib,
  python3,
  stdenv,
  zstd,
}: let
  version = "2.0.0";
  nvidiaVersion = "610.43.03";

  nvidiaKernelSource = fetchurl {
    url = "https://download.nvidia.com/XFree86/NVIDIA-kernel-module-source/NVIDIA-kernel-module-source-${nvidiaVersion}.tar.xz";
    hash = "sha256-fhGJI8eiPtw2EU1jJzpG4+BOmvmGlaQiA+esLf6fwdw=";
  };

  nvidiaInstaller = fetchurl {
    url = "https://download.nvidia.com/XFree86/Linux-x86_64/${nvidiaVersion}/NVIDIA-Linux-x86_64-${nvidiaVersion}-no-compat32.run";
    hash = "sha256-4IRFHbcwpt8p09dPZVdJxNI248lF99lLUgXoQxj+L5A=";
  };
in
  stdenv.mkDerivation {
    pname = "gpu-unlock";
    inherit version;

    src = fetchFromGitHub {
      owner = "Zagitta";
      repo = "gpu-unlock";
      rev = "7eb51bccae0a0b7e599e084d971170e9a1e82d0c";
      hash = "sha256-1KD/J1S1uyI5GGoTwQ1cU/sXeEKlG54exSvi6U+j73M=";
    };

    nativeBuildInputs = kernel.moduleBuildDependencies ++ [zstd];

    hardeningDisable = ["pic"];

    preBuild = ''
      mkdir -p nvidia-source assets
      tar -xf ${nvidiaKernelSource} -C nvidia-source
      ${python3}/bin/python firmware/extract_gsp.py ${nvidiaInstaller} assets
      ${python3}/bin/python firmware/extract_boot_assets.py \
        nvidia-source/NVIDIA-kernel-module-source-${nvidiaVersion} assets
      cd kernel/gpu_unlock
    '';

    makeFlags =
      kernelModuleMakeFlags
      ++ ["KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"];

    installFlags = [
      "-C"
      "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "M=$(PWD)"
      "INSTALL_MOD_PATH=$(out)"
      "INSTALL_MOD_DIR=extra"
    ];
    installTargets = ["modules_install"];

    postInstall = ''
      install -Dm644 -t "$out/lib/firmware/gpu-unlock/${nvidiaVersion}" \
        ../../assets/*.bin
      install -Dm644 ../../README.md \
        "$out/share/doc/gpu-unlock/README.md"
      install -Dm644 -t "$out/share/licenses/gpu-unlock" \
        ../../licenses/*.txt ../../firmware/NOTICE.md ../../assets/NVIDIA-LICENSE
    '';

    enableParallelBuilding = true;

    meta = {
      description = "Pre-driver tensor-core unlock for supported GeForce RTX GPUs";
      homepage = "https://github.com/Zagitta/gpu-unlock";
      license = with lib.licenses; [
        gpl2Only
        unfreeRedistributableFirmware
      ];
      platforms = ["x86_64-linux"];
    };
  }
