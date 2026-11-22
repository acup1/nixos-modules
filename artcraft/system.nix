{...}: {
  imports = [
    (import ../lib/component-packages.nix "artcraft" "system")
    ./packages/artcraft.nix
  ];
}
