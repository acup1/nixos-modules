{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wineWow64Packages.waylandFull

    gnome-sudoku
    bottles
  ];
}
