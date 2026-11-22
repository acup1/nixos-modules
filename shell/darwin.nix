{pkgs, ...}: {
  imports = [
    (import ../lib/component-packages.nix "shell" "system")
    (import ../lib/darwin-package-options.nix "shell" (import ./darwin-packages.nix {inherit pkgs;}))
  ];
}
