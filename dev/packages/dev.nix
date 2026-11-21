{pkgs, ...}: {
  components.dev.packages = with pkgs; [
    nodejs
    scdoc

    gcc
    libgccjit
    cling
    clang

    rustc
    rustup
    cargo

    arduino-ide

    go
    gnumake
    python3
  ];
}
