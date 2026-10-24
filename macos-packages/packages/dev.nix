{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gcc
    cling
    clang

    rustc
    cargo

    go
    gnumake
    python3
  ];
}
