{pkgs, ...}: {
  imports = [
    (import ../lib/component-packages.nix "fonts" "system")
    (import ../lib/darwin-package-options.nix "fonts" (import ./font-packages.nix {inherit pkgs;}))
  ];
}
