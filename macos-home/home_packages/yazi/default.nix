{pkgs, ...}: let
  yaziWithoutYa = pkgs.symlinkJoin {
    name = "yazi-no-ya";
    paths = [pkgs.yazi];
    postBuild = ''
      rm -f $out/bin/ya
    '';
  };
in {
  home.packages = [
    yaziWithoutYa
  ];
  xdg.configFile."yazi".source = ./.config/yazi;
}
