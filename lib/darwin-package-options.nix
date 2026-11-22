# Keep old per-package settings as defaults if the legacy bundle is also imported.
component: entries: {config, pkgs, ...}: {
  imports = [
    (import ./package-options.nix component (map (entry: entry // {
      available = pkgs.stdenv.hostPlatform.isDarwin && (entry.available or true);
      default = config.components.macos-packages.enabledPackages.${entry.legacyId or entry.id} or true;
    }) entries))
  ];
}
