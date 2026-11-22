{inputs, pkgs, ...}: {
  imports = [
    (import ../lib/component-packages.nix "browsers" "system")
    (import ../lib/darwin-package-options.nix "browsers" (import ./darwin-packages.nix {inherit inputs pkgs;}))
  ];
}
