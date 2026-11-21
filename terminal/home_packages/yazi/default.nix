{
  pkgs,
  config,
  inputs,
  ...
}: {
  components.terminal.packages = with pkgs; [
    yazi
  ];
  xdg.configFile."yazi".source = ./.config/yazi;
}
