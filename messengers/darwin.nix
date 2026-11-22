{lib, pkgs, ...}: let
  cask = import ../lib/darwin-cask.nix lib;
in {
  imports = [
    (import ../lib/component-packages.nix "messengers" "system")
    (import ../lib/darwin-package-options.nix "messengers" [
      {id = "telegram-desktop"; package = pkgs.telegram-desktop or null;}
      {id = "discord"; package = pkgs.discord or null;}
      (cask "rocketchat-desktop" "rocket-chat")
    ])
  ];
}
