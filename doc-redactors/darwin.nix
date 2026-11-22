{pkgs, ...}: {
  imports = [
    (import ../lib/component-packages.nix "doc-redactors" "system")
    (import ../lib/darwin-package-options.nix "doc-redactors" (import ./darwin-packages.nix {inherit pkgs;}))
  ];
}
