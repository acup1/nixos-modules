{pkgs, ...}: {
  components.messengers.packages = with pkgs; [
    telegram-desktop
    discord
    # discord-canary
    rocketchat-desktop
    # teams-for-linux
  ];
}
