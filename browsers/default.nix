import ../lib/component.nix {
  inputFlake = ./inputs;
  nixos = ./nixos.nix;
  darwin = ./darwin.nix;
  home = ./home.nix;
}
