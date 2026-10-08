{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nautilus
    # thunnar

    qimgv

    vlc
    mpv
  ];
}
