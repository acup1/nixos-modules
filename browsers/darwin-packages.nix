{pkgs, inputs, ...}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  zen = inputs.zen-browser or (
    if system == "aarch64-darwin"
    then builtins.getFlake "github:0xc000022070/zen-browser-flake/3c9c2843c3ca92de0c82f98e1c4641d95e7163f2?narHash=sha256-es8MSf8k9iRKAW0ny1Dfqo09imWwx0w561wbuz4u5Xk%3D"
    else {}
  );
in [
  {
    id = "zen-browser";
    package = zen.packages.${system}.default or null;
  }
]
