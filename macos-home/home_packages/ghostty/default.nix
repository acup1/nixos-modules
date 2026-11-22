{pkgs, ...}: {
  imports = [
    (import ../../../lib/package-options.nix "macos-home" [{
      id = "ghostty";
      package = pkgs.ghostty-bin or null;
      definitions.xdg.configFile."ghostty".source = ./.config/ghostty;
    }])
  ];
}
