{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "messengers" [
      { id = "telegram-desktop"; package = pkgs.telegram-desktop; }
      { id = "discord"; package = pkgs.discord; }
      { id = "rocketchat-desktop"; package = pkgs.rocketchat-desktop; }
    ])
  ];
}
