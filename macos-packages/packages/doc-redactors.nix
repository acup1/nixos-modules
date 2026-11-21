{pkgs, ...}: {
  components.macos-packages.packages = with pkgs; [
    typst
    texliveFull
    obsidian
  ];
}
