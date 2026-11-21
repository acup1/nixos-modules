{lib, pkgs, ...}: let
  system = pkgs.stdenv.hostPlatform.system;
  release = lib.importJSON ./release.json;
  hashes = release.hashes;
  asset = "nixos-installer-${system}";
  binary = pkgs.fetchurl {
    url = "https://github.com/acup1/nixos-installer/releases/download/v${release.version}/${asset}";
    hash = hashes.${system};
  };
  package = pkgs.runCommand "nixos-installer-${release.version}" {
    meta.mainProgram = "nixos-installer";
    meta.platforms = builtins.attrNames hashes;
  } ''
    install -Dm755 ${binary} "$out/bin/nixos-installer"
  '';
in {
  imports = [(import ../lib/component-packages.nix "nixos-installer" "system")];
  config = lib.mkIf (builtins.hasAttr system hashes) {
    components.nixos-installer.packages = [package];
  };
}
