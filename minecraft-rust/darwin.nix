{pkgs, ...}: {
  imports = [
    (import ../lib/component-packages.nix "minecraft-rust" "system")
    (import ../lib/package-options.nix "minecraft-rust" [{
      id = "minecraft-rust";
      available = pkgs.stdenv.hostPlatform.system == "aarch64-darwin";
      package = pkgs.callPackage ./package.nix {};
    }])
  ];
}
