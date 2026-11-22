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
    version = "0.19.2";
    bundleName = "ArtCraft Launcher";
    description = "Official launcher and updater for ArtCraft applications";
    linuxX86 = "sha256-Oamut3+FqwbWVUCxlPFYLsjCZSn34QqMnWwH/yGAtm0=";
    linuxArm = "sha256-qSrKhFZiShDxQ5ikMJ5NQk0amCA5k6Ki2UhBBNfW4t0=";
    darwin = "sha256-vg6ZAQulYNrjOZNhlnPQMWg+NbIfCza9aN7pkOIf18s=";
  };

  photocraft = mkApp "photocraft" {
    version = "0.23.1";
    bundleName = "PhotoCraft";
    description = "Photo editor and layered document tool written from scratch in Rust";
    linuxX86 = "sha256-Q4Ou9noHzDcK0lCm7WABUgXT5sRj+vP/Sw9nuBeMz8g=";
    linuxArm = "sha256-/MgcOK5ixy+p9P0ew9GDlkk7omFmJ5LWmVzDWQXOcdI=";
    darwin = "sha256-YGpSkXGIxl3HFwl4EYCg4yRODzt/QLL1uAFw6HNkQg0=";
    darwinCli = "sha256-puzcbUrdAogWQr2goLGRtJdBGGUfLsVkHccbLD/0t1I=";
  };

  vectorcraft = mkApp "vectorcraft" {
    version = "0.24.1";
    bundleName = "VectorCraft";
    description = "Vector illustration and graphics editor written in pure Rust";
    linuxX86 = "sha256-oJBRQlL94UVJWsb8Zdb/ExHWmJmOV7pDTV0IlsPR+/o=";
    linuxArm = "sha256-S5c1SJeJ0zbBykNEaJ60odSj8Lbo23+MBlnCTRBlNFU=";
    darwin = "sha256-je5ZlrDZX8CovIudlcrCSDSmI8sIA2oM6ou2wOl0yq0=";
    darwinCli = "sha256-fwyCYeXIMdloHkgnL5unO/hwLb9s64T5gXfHwAf63fI=";
  };

  filmcraft = mkApp "filmcraft" {
    version = "0.20.1";
    bundleName = "FilmCraft";
    description = "Nonlinear video editor written from scratch in pure Rust";
    linuxX86 = "sha256-Pk/qPLjUc+aPGJoKh5K6RhYPq1B62rOriSAHP9QfJPo=";
    linuxArm = "sha256-zc49gyYgx89xUOZgn9mK2XAufUxX+CeqtWLofYFuoT8=";
    darwin = "sha256-VyLw8hypZYPuJ9/Yi64j4KSmq4eGKmwACCyIxcdZ514=";
    darwinCli = "sha256-FlHZ3vtU+FPL1pAWQou59yp78m1W5HVbjip5U1/QrII=";
  };

  lightcraft = mkApp "lightcraft" {
    version = "0.21.1";
    bundleName = "LightCraft";
    description = "Non-destructive photo and RAW development editor in pure Rust";
    linuxX86 = "sha256-sSPeFpFYCaeeZLpO467p4c3tbvI7c3wG+Bzcfi8obWI=";
    linuxArm = "sha256-roxVfvcCjL+u/hBcJ8MM75SQ0lwZmAPD8cvgcrw517Y=";
    darwin = "sha256-tw9GysATkBVMmt+gaCLmaRuV/CcMUHsO0iCgDcWIux4=";
    darwinCli = "sha256-WAhrnSJNArXsntCOdtoEuh3F1R08KFzepBc1j6fqBuI=";
  };

  pdfcraft = mkApp "pdfcraft" {
    version = "0.21.1";
    bundleName = "PdfCraft";
    description = "PDF reader and editor written from scratch in pure Rust";
    linuxX86 = "sha256-wpGekETv/eMY5mgHrSohu7dKlVWzwLmfmtDEDPYc4l4=";
    linuxArm = "sha256-sI7+QWwdpFCwSz5OxfA4nXHXWA9DmPntoG0z0EcTx3A=";
    darwin = "sha256-Gtyb89MZ5wfpJHAE2wWjKgWWNONxD+ebwU+S9onKTUo=";
    darwinCli = "sha256-M3qfZEdEtX4Q3kHFc2blPFzPiECk1dxzIrF7m4P9wvo=";
  };

  effectcraft = mkApp "effectcraft" {
    version = "0.24.1";
    bundleName = "EffectCraft";
    description = "Motion graphics and visual compositing tool in pure Rust";
    linuxX86 = "sha256-XOA5NpAUQif6kYboIwitY4pu9tn5dsmW5tA7W1G2Wns=";
    linuxArm = "sha256-rRDERQZWgXYN6TUxF8bixFFn6rzM8O0ZveL1xayQhpU=";
    darwin = "sha256-ItARHR2qpxQu5iZqK4F00vTTdcTBLg38QKBNs9+zWFE=";
    darwinCli = "sha256-J4HtoZQ3KtR/TAx9+LHThQGj6Qu0mSgvV+lZioWVhnM=";
  };

  designcraft = mkApp "designcraft" {
    version = "0.20.1";
    bundleName = "DesignCraft";
    description = "Page and publication layout design editor in pure Rust";
    linuxX86 = "sha256-6RYw1M31eMyx4vOfiOJOhSDxSC1RrkcUZX7kceIjf0Q=";
    linuxArm = "sha256-IIw89zVl+nZcR+62AflP7EJegX0VzCEx36HB6+LQZiA=";
    darwin = "sha256-9Fsr9VQ8HYw30JqXHplCDW7z2XtuvjPjGzbSo8OesMI=";
    darwinCli = "sha256-oXh4OzHhr0j3rytRZWjshVN6SE37zFBXsPA8re6QwKs=";
  };

  wordcraft = mkApp "wordcraft" {
    version = "0.18.1";
    bundleName = "WordCraft";
    description = "Word processor reimplementation written in pure Rust";
    linuxX86 = "sha256-MSoFfUbdgFl8EtzP0Ql84l7epAuqrrULy28BrBrrrbU=";
    linuxArm = "sha256-P0r8BZg1c3itivmy43osFx9t1HTJIGyc8M9W6mhiWe0=";
    darwin = "sha256-ifbgqRD4rVqBXYAkx5Mk0gW1b80uBd7tAQ6QFvWBPew=";
    darwinCli = "sha256-NDl89vz3PuiujVPKsI+9/CEyYtu2dTwpZeu3zeN7hhY=";
  };

  soundcraft = mkApp "soundcraft" {
    version = "0.20.1";
    bundleName = "SoundCraft";
    description = "Digital audio workstation (DAW) in pure Rust";
    linuxX86 = "sha256-yu/PhcTxE4cX1ZLTHOW+B/L8phbsNtY/rGdgze++KKk=";
    linuxArm = "sha256-k8bG5eN8Dles6nYgH6rMd37Q97j7i4a6qnG7Vc/TPf0=";
    darwin = "sha256-6x3TktfDhntWmqngjAFkJwloAAFv8z+PTgGS5D2ebAs=";
    darwinCli = "sha256-hm/L/jIXnmZSFZOFtPZ2unVuHK24j6w+kXPpZD92O1E=";
  };

  deckcraft = mkApp "deckcraft" {
    version = "0.18.1";
    bundleName = "DeckCraft";
    description = "Presentations and slide deck editor in pure Rust";
    linuxX86 = "sha256-W659VWZjhiRBHvlo8lMqszWNwoCIQURYPkl8VjHbiiY=";
    linuxArm = "sha256-P70AXOOCyFOtBW3Ke5N4AvwO9rhWTspamaUrZwwVnpQ=";
    darwin = "sha256-MyHRH2NTs/+d4yjyFAfXUn8fkCnIPatOOrc09RbToFU=";
    darwinCli = "sha256-EJkvc8iKTANh3Q/sOk10kHMf+z6pZY7iJ0s5bjNBrwA=";
  };

  cadcraft = mkApp "cadcraft" {
    version = "0.20.1";
    bundleName = "CADCraft";
    description = "Computer-aided design and drafting CAD app in pure Rust";
    linuxX86 = "sha256-V7bxtBtPPFQqgvEDIC7Rp3lEDl/40lwI72ar2hqMsbk=";
    linuxArm = "sha256-sUnbS99h0TX8tAznNhgox1sY1vP3EOFlyhfzCBnSMhI=";
    darwin = "sha256-ye8c8CI05qXoVCh6ZP4xStbVMieRXDxmZPpBYeKh/nA=";
    darwinCli = "sha256-J1QFWk8xjQKPucx6rAqYmH0hwrXCDwecov6xRp8o+zs=";
  };

  gridcraft = mkApp "gridcraft" {
    version = "0.19.1";
    bundleName = "GridCraft";
    description = "Spreadsheet editor in pure Rust";
    linuxX86 = "sha256-jZe7otW7AP1p7VUGSFLB/ZFN5A1ezVXKAcjfgbgolG0=";
    linuxArm = "sha256-wFNzo2bm3e0yATgMuCs6ChN1aaGxItN8Gw7PAcvUa3U=";
    darwin = "sha256-1QFl54uONau+aKp8bzbCkAI97GUNiqeXrCNHqTD2wZc=";
    darwinCli = "sha256-fCiV660LvZK2XGIrp+Iq2lbgSYBl39vUMxEboeIl64o=";
  };
}
