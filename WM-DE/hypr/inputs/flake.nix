{
  description = "Inputs for the hypr desktop component";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    iio-hyprland.url = "github:JeanSchoeller/iio-hyprland";
  };
  outputs = _: {};
}
