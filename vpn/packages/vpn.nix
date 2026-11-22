{pkgs, ...}: {
  imports = [(import ../../lib/package-options.nix "vpn" [
    {id = "amnezia-vpn"; package = pkgs.amnezia-vpn;}
    # hiddify-app
    # v2raya
    {id = "clash-verge-rev"; package = pkgs.clash-verge-rev;}
    # flclash
  ])];
}
