{pkgs, ...}: {
  imports = [
    (import ../../../lib/package-options.nix "macos-home" [
      { id = "btop"; package = pkgs.btop; definitions = { xdg.configFile."btop/btop.conf".source = ./.config/btop/btop.conf; }; }
    ])
  ];
}
