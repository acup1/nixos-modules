{pkgs, ...}: {
  imports = [(import ../../../lib/package-options.nix "common" [{
    id = "libgbm";
    definitions = {
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [ libgbm ];
      };
    };
  }])];
}
