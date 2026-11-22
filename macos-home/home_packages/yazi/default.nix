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
  imports = [
    (import ../../../lib/package-options.nix "macos-home" [{
      id = "yazi";
      available = yaziAvailable;
      package = yaziWithoutYa;
      definitions.xdg.configFile."yazi".source = ./.config/yazi;
    }])
  ];
}
