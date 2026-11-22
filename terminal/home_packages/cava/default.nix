{pkgs, ...}: {
  imports = [
    (import ../../../lib/package-options.nix "terminal" [
      { id = "cava"; package = pkgs.cava; definitions = { xdg.configFile."cava".source = ./.config/cava; }; }
    ])
  ];
}
