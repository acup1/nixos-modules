{lib, pkgs, ...}: {
  imports = [(import ../lib/component-packages.nix "minecraft-rust" "system")];
  config = lib.mkIf (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") {
    components.minecraft-rust.packages = [ (pkgs.callPackage ./package.nix {}) ];
  };
}
