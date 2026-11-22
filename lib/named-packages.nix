# Use for switches backed by identically named nixpkgs attributes.
component: {names, default ? true}: {pkgs, ...}: {
  imports = [
    (import ./package-options.nix component (map (id: {
      inherit id default;
      package = pkgs.${id} or null;
    }) names))
  ];
}
