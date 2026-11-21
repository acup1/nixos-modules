{
  pkgs,
  config,
  inputs,
  ...
}: {
  components.terminal.packages = with pkgs; [
    btop
  ];
  xdg.configFile."btop/btop.conf".source = ./.config/btop/btop.conf;
}
