{pkgs, ...}: {
  imports = [
    (import ../lib/component-packages.nix "printing" "system")
    (import ../lib/darwin-package-options.nix "printing" (import ./darwin-packages.nix {inherit pkgs;}))
  ];
}
