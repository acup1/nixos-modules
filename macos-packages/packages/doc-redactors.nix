{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    typst
    texliveFull
    obsidian
  ];
}
