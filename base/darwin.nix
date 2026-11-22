{pkgs, ...}: {
  imports = [
    (import ../lib/named-packages.nix "base" {names = ["openssh"]; default = false;})
    (import ../lib/component-packages.nix "base" "system")
    ./packages/base.nix
    (import ../lib/package-options.nix "base" [{
      id = "nh";
      package = pkgs.nh or null;
      default = false;
      description = "Install the nh command for rebuilding Nix configurations.";
    }])
  ];
}
