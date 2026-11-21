import ../lib/component.nix {
  nixos = ./nixos.nix;
  home = ./home.nix;
  homePlatform = "linux";
}
