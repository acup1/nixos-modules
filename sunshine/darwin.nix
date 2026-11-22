{pkgs, ...}: {
  imports = [
    (import ../lib/component-packages.nix "sunshine" "system")
    (import ../lib/darwin-package-options.nix "sunshine" [
      {id = "sunshine"; package = pkgs.sunshine or null; available = pkgs.stdenv.hostPlatform.system == "aarch64-darwin";}
    ])
  ];
}
