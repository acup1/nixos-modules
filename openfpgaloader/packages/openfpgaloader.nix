{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    openfpgaloader
  ];
}

