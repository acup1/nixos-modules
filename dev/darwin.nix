{lib, pkgs, ...}: {
  imports = [
    (import ../lib/component-packages.nix "dev" "system")
    (import ../lib/darwin-package-options.nix "dev" (import ./darwin-packages.nix {inherit lib pkgs;}))
  ];
}
