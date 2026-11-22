{lib, pkgs, ...}: {
  imports = [
    (import ../../lib/named-packages.nix "common" {names = ["xclip" "orchis-theme"]; default = false;})
    (import ../../lib/package-options.nix "common" [
      ((import ../../lib/darwin-cask.nix lib "xorg-server" "xquartz") // {default = false;})
      {id = "opentabletdriver"; package = pkgs.callPackage ./opentabletdriver-darwin.nix {}; default = false;}
    ])
    (import ../../lib/component-packages.nix "common" "system")
  ];
}
