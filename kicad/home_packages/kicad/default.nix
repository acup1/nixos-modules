{pkgs, ...}: {
  imports = [
    (import ../../../lib/package-options.nix "kicad" [
      { id = "kicad"; package = pkgs.kicad; available = (!(pkgs.stdenv.hostPlatform.isDarwin && (pkgs.kicad.meta.broken or false))); }
    ])
  ];
}
