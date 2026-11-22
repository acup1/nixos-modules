{
  imports = [
    ../terminal-emulators/home-module.nix
    ../shell/home-module.nix
    ../cli-tools/home-module.nix
    (import ./compatibility.nix "terminal" "home" [
      {
        name = "terminal-emulators";
        ids = ["ghostty" "nerd-fonts-code-new-roman" "nerd-fonts-symbols-only"];
      }
      {name = "shell"; ids = ["zsh" "starship"];}
      {name = "cli-tools"; ids = ["btop" "cava" "yazi"];}
    ])
  ];
}
