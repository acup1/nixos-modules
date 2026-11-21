{lib, pkgs, ...}: {
  components.kicad.packages = lib.optional
    (!(pkgs.stdenv.hostPlatform.isDarwin && (pkgs.kicad.meta.broken or false)))
    pkgs.kicad;
}
