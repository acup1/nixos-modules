{ pkgs ? import <nixpkgs> {} }:

let
  mkArtCraftApp = pkgs.callPackage ./generic.nix {};
in {
  craft-launcher = mkArtCraftApp {
    pname = "artcraft-launcher";
    version = "0.3.2";
    repoName = "craft-launcher";
    archivePrefix = "artcraft-launcher-0.3.2-linux-x86_64";
    hash = "sha256-QcdXJdk6GqwV1ZH+RBuBQVDdxXEYC7pEhxxRVpk+3aM=";
    description = "Official launcher and updater for ArtCraft applications";
    metaName = "artcraft-launcher";
  };

  photocraft = mkArtCraftApp {
    pname = "photocraft";
    version = "0.7.0";
    hash = "sha256-ZB+DElL9MbQ+4aEuVy10QuVlLC5b9iPeCFdBw3DwyR0=";
    description = "Photo editor and layered document tool written from scratch in Rust";
  };

  vectorcraft = mkArtCraftApp {
    pname = "vectorcraft";
    version = "0.9.0";
    hash = "sha256-r7xKCQR0Df0SCOcXZk6ylJZQVedMInwqw9xTr1AuRqQ=";
    description = "Vector illustration and graphics editor written in pure Rust";
  };

  filmcraft = mkArtCraftApp {
    pname = "filmcraft";
    version = "0.6.0";
    hash = "sha256-s9cG1Zlpnq12tGop1Wlyh7n3WgvJ60D3cz23ZX2uggQ=";
    description = "Nonlinear video editor written from scratch in pure Rust";
  };

  lightcraft = mkArtCraftApp {
    pname = "lightcraft";
    version = "0.6.0";
    hash = "sha256-1zjxazpxex5mcWmBqk+NvWjKpb+dBNF1gBoiePGPafE=";
    description = "Non-destructive photo and RAW development editor in pure Rust";
  };

  pdfcraft = mkArtCraftApp {
    pname = "pdfcraft";
    version = "0.6.0";
    hash = "sha256-mhNuceN7RZ7VdG2+GaNkzoTPXZlcb2yYr2FH2Bg5ClM=";
    description = "PDF reader and editor written from scratch in pure Rust";
  };

  effectcraft = mkArtCraftApp {
    pname = "effectcraft";
    version = "0.8.0";
    hash = "sha256-clyIzzeRItcPlB3T7ay1RHnWP/HioA+uMY6u4CrXYsQ=";
    description = "Motion graphics and visual compositing tool in pure Rust";
  };

  designcraft = mkArtCraftApp {
    pname = "designcraft";
    version = "0.6.0";
    hash = "sha256-q7ZhzS/FNnfQQP4L4/JBu7jA+tlhkZKoMQnVO9UUv7k=";
    description = "Page and publication layout design editor in pure Rust";
  };

  wordcraft = mkArtCraftApp {
    pname = "wordcraft";
    version = "0.5.0";
    hash = "sha256-mUuzdkee9tdnNc9AKeXvPC1SqFpMms3is3wzsZxXAgM=";
    description = "Word processor reimplementation written in pure Rust";
  };

  soundcraft = mkArtCraftApp {
    pname = "soundcraft";
    version = "0.5.0";
    hash = "sha256-sTBbGnunuFYyBAhNwN5lLvQjZ2nM9Gpef1RaShBg6AM=";
    description = "Digital audio workstation (DAW) in pure Rust";
  };

  deckcraft = mkArtCraftApp {
    pname = "deckcraft";
    version = "0.5.0";
    hash = "sha256-wmSMYHH2MezGY5zmt9YPaO7YPd6rprFVmwfFBGhjEXw=";
    description = "Presentations and slide deck editor in pure Rust";
  };

  cadcraft = mkArtCraftApp {
    pname = "cadcraft";
    version = "0.5.0";
    hash = "sha256-A2w7QBmHtqmZG1/Hugl9W3F+jRhSL3w/YmsPajY+II4=";
    description = "Computer-aided design and drafting CAD app in pure Rust";
  };

  gridcraft = mkArtCraftApp {
    pname = "gridcraft";
    version = "0.5.0";
    hash = "sha256-5lBcL5KfmFTDUKDfJhicTlbIrfh8xhYl+A1qjuwrYo0=";
    description = "Spreadsheet editor in pure Rust";
  };
}
