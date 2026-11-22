{
  imports = [
    ../terminal-emulators/home-module.nix
    ../shell/home-module.nix
    ../cli-tools/home-module.nix
    (import ../terminal/compatibility.nix "macos-home" "home" [
      {name = "terminal-emulators"; ids = ["ghostty"];}
      {name = "shell"; ids = ["zsh" "starship"];}
      {name = "cli-tools"; ids = ["btop" "yazi"];}
    ])
  ];
}
