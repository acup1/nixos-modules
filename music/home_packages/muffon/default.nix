{
  pkgs,
  config,
  inputs,
  ...
}: {
  components.music.packages = with pkgs; [
    muffon
  ];
  # xdg.configFile."ghostty".source = ./.config/ghostty;
}
