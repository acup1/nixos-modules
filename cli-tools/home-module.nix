{config, lib, options, pkgs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  yazi =
    if isDarwin
    then pkgs.symlinkJoin {
      name = "yazi-no-ya";
      paths = [pkgs.yazi];
      postBuild = ''
        rm -f "$out/bin/ya"
      '';
    }
    else pkgs.yazi;
  terminalSelected = lib.hasAttrByPath ["components" "terminal" "packages"] options;
in {
  imports = [
    (import ../terminal/profile.nix "cli-tools" "home")
    (import ../lib/package-options.nix "cli-tools" [
      {
        id = "btop";
        package = pkgs.btop;
        definitions.xdg.configFile."btop/btop.conf".source =
          if isDarwin then ./home_packages/btop/darwin/btop.conf else ./home_packages/btop/linux/btop.conf;
      }
      {
        id = "cava";
        available = isLinux || terminalSelected || config.components.cli-tools.standalone;
        package = pkgs.cava;
        definitions.xdg.configFile.cava.source = ./home_packages/cava/config;
      }
      {
        id = "yazi";
        available = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.yazi;
        package = yazi;
        definitions.xdg.configFile.yazi.source =
          if isDarwin then ./home_packages/yazi/darwin else ./home_packages/yazi/linux;
      }
    ])
  ];
}
