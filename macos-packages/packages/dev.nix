{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gcc
    cling
    clang

    go
    gnumake
    python3
  ];
}
