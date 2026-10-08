{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    amnezia-vpn
    # hiddify-app
    # v2raya
    clash-verge-rev
    # flclash
  ];
}
