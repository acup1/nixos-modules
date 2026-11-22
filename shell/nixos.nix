{
  imports = [
    (import ../lib/component-packages.nix "shell" "system")
    (import ../lib/package-options.nix "shell" [
      {id = "zsh"; definitions.programs.zsh.enable = true;}
    ])
  ];
}
