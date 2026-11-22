{ pkgs ? import <nixpkgs> {} }:

let
  system = pkgs.stdenv.hostPlatform.system;
  mkLinux = pkgs.callPackage ./linux-package.nix {};
  mkDarwin = pkgs.callPackage ./darwin-package.nix {};

  mkApp = repo: {
    pname ? repo,
    version,
    bundleName,
    description,
    linuxX86,
    linuxArm,
    darwin,
    darwinCli ? null,
  }: let
    releaseUrl = "https://github.com/storytold/${repo}/releases/download/v${version}";
    common = { inherit pname version releaseUrl description; };
    macos = mkDarwin (common // {
      inherit bundleName;
      hash = darwin;
      cliHash = darwinCli;
    });
  in {
    x86_64-linux = mkLinux (common // { hash = linuxX86; });
    aarch64-linux = mkLinux (common // { hash = linuxArm; });
    aarch64-darwin = macos;
    x86_64-darwin = macos;
  }.${system} or null;
in {
  craft-launcher = mkApp "craft-launcher" {
    pname = "artcraft-launcher";
    version = "0.3.2";
    bundleName = "ArtCraft Launcher";
    description = "Official launcher and updater for ArtCraft applications";
    linuxX86 = "sha256-QcdXJdk6GqwV1ZH+RBuBQVDdxXEYC7pEhxxRVpk+3aM=";
    linuxArm = "sha256-T99GC/SyaFwcFbrUspiYm+B4zYQXAIYsYgern0AkfvE=";
    darwin = "sha256-fDMlIJxt+gYqhGfQ9l2vyw5qSTwhmFRUkMR7dDvgkVg=";
  };

  photocraft = mkApp "photocraft" {
    version = "0.7.0";
    bundleName = "PhotoCraft";
    description = "Photo editor and layered document tool written from scratch in Rust";
    linuxX86 = "sha256-ZB+DElL9MbQ+4aEuVy10QuVlLC5b9iPeCFdBw3DwyR0=";
    linuxArm = "sha256-hUDrHbgMrUpaV85UoMhmEW2qADYSpELpQ4LEIqCy/ak=";
    darwin = "sha256-zQQ4nxVRjGII7zoeS5sW+e270ezj+mP3h2tdjUEciko=";
    darwinCli = "sha256-yvQe7hgn73QLxElfsf7nf2pOC+gvsTEQatBs1ZH9gJE=";
  };

  vectorcraft = mkApp "vectorcraft" {
    version = "0.9.0";
    bundleName = "VectorCraft";
    description = "Vector illustration and graphics editor written in pure Rust";
    linuxX86 = "sha256-r7xKCQR0Df0SCOcXZk6ylJZQVedMInwqw9xTr1AuRqQ=";
    linuxArm = "sha256-XB/TtfUJQ744TD5oLvHFcwBAWa9Q1qgGaYGhyv/qjEM=";
    darwin = "sha256-rDfN/3n0v3UQfHXseNZf0jzYvJ7X2JXcoiCs3BWzhuk=";
    darwinCli = "sha256-Dm/DjdHsQy+0oTPuGx7+k11znw/LN2sZJe6JRz1Vphs=";
  };

  filmcraft = mkApp "filmcraft" {
    version = "0.6.0";
    bundleName = "FilmCraft";
    description = "Nonlinear video editor written from scratch in pure Rust";
    linuxX86 = "sha256-s9cG1Zlpnq12tGop1Wlyh7n3WgvJ60D3cz23ZX2uggQ=";
    linuxArm = "sha256-qgrVRGnhwle2v7Z1P3XoKZDN8or9nalULlQaVMHVjb8=";
    darwin = "sha256-Po2SoILJiqNHfAAxPQeEwY9oHpTtkaSUcS1NizYpfjs=";
    darwinCli = "sha256-ft4qo+iZTKg2NhjvZJUmVGz5UbEajq+JW5RxEBz1vTI=";
  };

  lightcraft = mkApp "lightcraft" {
    version = "0.6.0";
    bundleName = "LightCraft";
    description = "Non-destructive photo and RAW development editor in pure Rust";
    linuxX86 = "sha256-1zjxazpxex5mcWmBqk+NvWjKpb+dBNF1gBoiePGPafE=";
    linuxArm = "sha256-UEUlCFQkrHhnWsGV6fxMTnOgHesDTaSR2LDjMmw7MaQ=";
    darwin = "sha256-cwISQ+NR16XqePDIqten6au6Rxt74y6PzU0D6YB4tQo=";
    darwinCli = "sha256-6HAU1J1NvwCFH1/zAF7NDVQYzNd69Pcqp1A3Tj9IA84=";
  };

  pdfcraft = mkApp "pdfcraft" {
    version = "0.6.0";
    bundleName = "PdfCraft";
    description = "PDF reader and editor written from scratch in pure Rust";
    linuxX86 = "sha256-mhNuceN7RZ7VdG2+GaNkzoTPXZlcb2yYr2FH2Bg5ClM=";
    linuxArm = "sha256-IPtRddtcmSNVtvHHPMWxY74F0vTycK/vahhLuuOzilk=";
    darwin = "sha256-WFXok8sNQGsa723tXe4xTyzXK3g6uC5XxD8oOcMwewo=";
    darwinCli = "sha256-hb+AsHMvJVbzEz4laT0fHf3SaDzWI2qhVLsZ9zUVt88=";
  };

  effectcraft = mkApp "effectcraft" {
    version = "0.8.0";
    bundleName = "EffectCraft";
    description = "Motion graphics and visual compositing tool in pure Rust";
    linuxX86 = "sha256-clyIzzeRItcPlB3T7ay1RHnWP/HioA+uMY6u4CrXYsQ=";
    linuxArm = "sha256-Z3g/5lUyh54TrrpECosPJgsPvcmzbpkRgXIL2meusn4=";
    darwin = "sha256-uNlGvUizyQhPkhC+nUXkGmxsDxBgNlvfDoQrRAlhpFM=";
    darwinCli = "sha256-qLEztT8pyWdpApXNZlLciUJXsTJCTuaLaAvQmQiqNVM=";
  };

  designcraft = mkApp "designcraft" {
    version = "0.6.0";
    bundleName = "DesignCraft";
    description = "Page and publication layout design editor in pure Rust";
    linuxX86 = "sha256-q7ZhzS/FNnfQQP4L4/JBu7jA+tlhkZKoMQnVO9UUv7k=";
    linuxArm = "sha256-n9SgVq6mjoD8cFCY2WAz4MZ2jo/7nLmz0Pc41aDv7rU=";
    darwin = "sha256-4dUg4imv8ZWbXO96v9v6SLo8rM34G/d9AaWc81hVMYo=";
    darwinCli = "sha256-vVxD2HblE1a0I2DJQtNVkImPwwg/Nn/zPC18YKIH68o=";
  };

  wordcraft = mkApp "wordcraft" {
    version = "0.8.0";
    bundleName = "WordCraft";
    description = "Word processor reimplementation written in pure Rust";
    linuxX86 = "sha256-Ds4Hzz2RuSPf2A+QMQ4EmDveZvAnnGtg3c6JWW3eDd8=";
    linuxArm = "sha256-qGLeIlbkPJh9yOoAm6Uqwl2zQJH9ZJtmYTOTGsaOAsw=";
    darwin = "sha256-nHwFjkvA6j3U5/NQ6TS15f9XmHI5N/OCx3R4ppePieM=";
    darwinCli = "sha256-kx8id6NX59dyZt3O6lZUULECynv54GNIIRYve6thbb4=";
  };

  soundcraft = mkApp "soundcraft" {
    version = "0.5.0";
    bundleName = "SoundCraft";
    description = "Digital audio workstation (DAW) in pure Rust";
    linuxX86 = "sha256-sTBbGnunuFYyBAhNwN5lLvQjZ2nM9Gpef1RaShBg6AM=";
    linuxArm = "sha256-FEqs2BxJQKTDec8vC2jvBnqmPMMpQRzaz7W55QKrK2k=";
    darwin = "sha256-LRzrAKag1VM976CP+V1JQy9+dFXYMWE9nRdnwwv0maI=";
    darwinCli = "sha256-sC8+32SbPuKsSZ8Ull8OjyKTKf1JgG1u6mSJUCLqgYc=";
  };

  deckcraft = mkApp "deckcraft" {
    version = "0.5.0";
    bundleName = "DeckCraft";
    description = "Presentations and slide deck editor in pure Rust";
    linuxX86 = "sha256-wmSMYHH2MezGY5zmt9YPaO7YPd6rprFVmwfFBGhjEXw=";
    linuxArm = "sha256-n7Q67bmyI89i800rUJAMYzenzVyzF4ubUwu5OiE8QC0=";
    darwin = "sha256-n/qpelBR36+CIKmJu07slpzH09ojc8Qx7zfS1O8bLA4=";
    darwinCli = "sha256-5PhWLExWM30q5AadGC4uMl3b9wC2JIJy2W8+RpcCmQs=";
  };

  cadcraft = mkApp "cadcraft" {
    version = "0.5.0";
    bundleName = "CADCraft";
    description = "Computer-aided design and drafting CAD app in pure Rust";
    linuxX86 = "sha256-A2w7QBmHtqmZG1/Hugl9W3F+jRhSL3w/YmsPajY+II4=";
    linuxArm = "sha256-FfUEfB7c5LKPVMAM9ariVrj8wL3WF+TeyIocVLJs76g=";
    darwin = "sha256-98moRwfq5YQF2JMHZKv92suJUxVx1jpKSdm5tzX2+Kc=";
    darwinCli = "sha256-iDTPb84F5i8FM5Fa7EgkHbm4nzDj4oIcd7ulR2sOkFM=";
  };

  gridcraft = mkApp "gridcraft" {
    version = "0.5.0";
    bundleName = "GridCraft";
    description = "Spreadsheet editor in pure Rust";
    linuxX86 = "sha256-5lBcL5KfmFTDUKDfJhicTlbIrfh8xhYl+A1qjuwrYo0=";
    linuxArm = "sha256-1fOgyopPvYc3QL8SNFFVU1bKgxDw/WZwcpmNvPc6Jo8=";
    darwin = "sha256-43IXCtladiXjezFbFo2L4qXSVH3m3iUvg46Bu33phRM=";
    darwinCli = "sha256-RVm0LZa6/LxBgMx/CdX0KFl+wZ1EfD3y5LRYr8tMBPw=";
  };
}
