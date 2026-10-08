{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    fxlinuxprint
    cups
  ];
}
