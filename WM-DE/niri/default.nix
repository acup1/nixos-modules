import ../../lib/component.nix {
  inputFlake = ./inputs;
  nixos = ./nixos.nix;
  home = ./home.nix;
  homePlatform = "linux";
}
