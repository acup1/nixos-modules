{pkgs, ...}: {
  components.openfpgaloader.packages = with pkgs; [
    openfpgaloader
  ];
}

