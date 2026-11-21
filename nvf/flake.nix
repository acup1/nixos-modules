{
  description = "Neovim configuration for Home Manager";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {nvf, ...}: {
    homeManagerModules.default = import ./settings.nix nvf;
  };
}
