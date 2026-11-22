{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "sound" [
      { id = "playerctl"; package = pkgs.playerctl; }
      { id = "pipewire"; package = pkgs.pipewire; }
    ])
  ];
}
