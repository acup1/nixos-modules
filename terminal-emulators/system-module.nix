{pkgs, ...}: {
  imports = [
    (import ../terminal/profile.nix "terminal-emulators" "system")
    (import ../lib/package-options.nix "terminal-emulators" [
      {id = "alacritty"; package = pkgs.alacritty;}
    ])
  ];
}
