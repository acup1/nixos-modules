{config, lib, pkgs, ...}: let
  enabled = config.components.macos-packages.enabledPackages;
in {
  imports = [
    (import ../../lib/package-options.nix "macos-packages" [
      { id = "cling"; package = pkgs.cling; }
      { id = "clang"; package = pkgs.clang; }
      { id = "jre"; package = pkgs.jre; }
      { id = "rustc"; package = pkgs.rustc; }
      { id = "cargo"; package = pkgs.cargo; }
      { id = "go"; package = pkgs.go; }
      { id = "gnumake"; package = pkgs.gnumake; }
      { id = "python3"; package = pkgs.python3; }
    ])
  ];

  environment.variables = lib.mkIf (lib.any (id: enabled.${id}) ["cling" "clang" "jre" "rustc" "cargo" "go" "gnumake" "python3"]) {
    LIBRARY_PATH = lib.makeLibraryPath [pkgs.libiconv];
    MACOSX_DEPLOYMENT_TARGET = "14.0";
  };
}
