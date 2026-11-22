{pkgs, ...}: {
  imports = [
    (import ../../../lib/package-options.nix "terminal" [
      { id = "btop"; package = pkgs.btop; definitions = { xdg.configFile."btop/btop.conf".source = ./.config/btop/btop.conf; }; }
    ])
  ];
}
