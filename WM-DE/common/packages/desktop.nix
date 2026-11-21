{pkgs, ...}: {
  components.common.packages = with pkgs; [
    cliphist
    fuzzel
    #wl-clipboard-rs
    wl-clipboard-x11
    xclip
    brightnessctl
    xwayland-satellite
    slurp
    grim
    wl-clipboard
  ];
}
