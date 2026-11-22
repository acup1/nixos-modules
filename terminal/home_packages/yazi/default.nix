{pkgs, ...}: {
  imports = [
    (import ../../../lib/package-options.nix "terminal" [
      { id = "yazi"; package = pkgs.yazi; definitions = { xdg.configFile."yazi".source = ./.config/yazi; }; }
    ])
  ];
}
