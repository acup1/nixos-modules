{pkgs, ...}: {
  components.macos-packages.packages = with pkgs; [
    cups
    p7zip
    nodejs
  ];
}
