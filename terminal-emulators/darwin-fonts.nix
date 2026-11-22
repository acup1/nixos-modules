component: {pkgs, ...}: let
  availablePackages = import ../lib/available-packages.nix pkgs;
  font = name: {
    id = "nerd-fonts-${name}";
    default = false;
    definitions.fonts.packages = availablePackages [ (pkgs.nerd-fonts.${name} or null) ];
  };
in {
  imports = [
    (import ../lib/package-options.nix component (map font ["code-new-roman" "symbols-only"]))
  ];
}
