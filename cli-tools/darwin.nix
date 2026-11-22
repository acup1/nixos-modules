{pkgs, ...}: {
  imports = [
    (import ../lib/component-packages.nix "cli-tools" "system")
    (import ../lib/darwin-package-options.nix "cli-tools" (import ./darwin-packages.nix {inherit pkgs;}))
  ];
}
