{...}: {
  imports = [
    (import ../lib/component-packages.nix "openfpgaloader" "system")
    ./packages/openfpgaloader.nix
  ];
}
