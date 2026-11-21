{ pkgs, ... }: {

  components.browsers.packages = with pkgs; [
    google-chrome
    tor-browser
  ];
}
