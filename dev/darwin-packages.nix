{lib, pkgs, ...}: let
  developerTool = id: package: {
    inherit id package;
    definitions.environment.variables = {
      LIBRARY_PATH = lib.makeLibraryPath [pkgs.libiconv];
      MACOSX_DEPLOYMENT_TARGET = "14.0";
    };
  };
in [
  {id = "nodejs"; package = pkgs.nodejs;}
  (developerTool "cling" pkgs.cling)
  (developerTool "clang" pkgs.clang)
  (developerTool "jre" pkgs.jre)
  (developerTool "rustc" pkgs.rustc)
  (developerTool "cargo" pkgs.cargo)
  (developerTool "go" pkgs.go)
  (developerTool "gnumake" pkgs.gnumake)
  (developerTool "python3" pkgs.python3)
]
