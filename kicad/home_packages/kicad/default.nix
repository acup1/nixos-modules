{
  pkgs,
  config,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    kicad
  ];
}
