{
  description = "Inputs for the common desktop component";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    dms.url = "github:AvengeMedia/DankMaterialShell/stable";
    dms.inputs.nixpkgs.follows = "nixpkgs";
    waylandkb.url = "github:acup1/waylandkb";
  };
  outputs = _: {};
}
