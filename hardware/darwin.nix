{pkgs, ...}: {
  imports = [
    (import ../lib/component-packages.nix "hardware" "system")
    (import ../lib/package-options.nix "hardware" [{
      id = "hal-hardware-analyzer";
      package = pkgs.hal-hardware-analyzer or null;
      default = false;
    }])
  ];
}
