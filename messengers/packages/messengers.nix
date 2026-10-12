{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    telegram-desktop
    discord
    # discord-canary
    rocketchat-desktop
    # teams-for-linux
  ];
}
