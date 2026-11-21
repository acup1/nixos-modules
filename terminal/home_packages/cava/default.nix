{
  pkgs,
  config,
  inputs,
  ...
}: {
  components.terminal.packages = with pkgs; [
    cava
  ];
  xdg.configFile."cava".source = ./.config/cava;
}
