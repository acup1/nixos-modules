{lib, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cling
    clang

    rustc
    cargo

    go
    gnumake
    python3
  ];

  environment.variables = {
    LIBRARY_PATH = lib.makeLibraryPath [pkgs.libiconv];
    MACOSX_DEPLOYMENT_TARGET = "14.0";
  };
}
