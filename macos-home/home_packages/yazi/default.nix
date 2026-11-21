{lib, pkgs, ...}: let
  yaziAvailable = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.yazi;
  yaziWithoutYa = pkgs.symlinkJoin {
    name = "yazi-no-ya";
    paths = [pkgs.yazi];
    postBuild = ''
      rm -f $out/bin/ya
    '';
  };
in {
  components.macos-home.packages = lib.optional yaziAvailable yaziWithoutYa;
  xdg.configFile."yazi" = lib.mkIf yaziAvailable {
    source = ./.config/yazi;
  };
}
