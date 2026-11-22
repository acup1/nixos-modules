{
  description = "Inputs for the devops component";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    winapps.url = "github:winapps-org/winapps";
    winapps.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = _: {};
}
