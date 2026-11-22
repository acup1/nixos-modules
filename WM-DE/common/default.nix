import ../../lib/component.nix {
  nixos = ./nixos.nix;
  darwin = ./darwin.nix;
  home = ./home.nix;
  homePlatform = "linux";
}
