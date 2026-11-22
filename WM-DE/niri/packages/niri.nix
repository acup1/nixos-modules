{pkgs, ...}: {
  imports = [(import ../../../lib/package-options.nix "niri" (with pkgs; [
    {id = "iio-niri"; package = iio-niri;}
  ]))];
}
