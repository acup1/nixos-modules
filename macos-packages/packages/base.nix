{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cups
    p7zip
    nodejs
  ];
}
