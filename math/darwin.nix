{...}: {
  imports = [
    (import ../lib/component-packages.nix "math" "system")
    ./packages/math.nix
  ];
}
