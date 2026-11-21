{pkgs, ...}: {
  components.file-viewers.packages = with pkgs; [
    nautilus
    # thunnar

    qimgv

    vlc
    mpv
  ];
}
