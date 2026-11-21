{lib, pkgs, ...}: let
  inherit (pkgs.stdenv) hostPlatform;
  zen = builtins.getFlake "github:youwen5/zen-browser-flake";
  zenPackage = zen.packages.${hostPlatform.system}.default or null;
in {
  components.browsers.packages = lib.optional
    (hostPlatform.isLinux && zenPackage != null)
    (zenPackage.overrideAttrs (old: {
      # Zen loads AAC/H.264 decoders at runtime; keep a supported FFmpeg major.
      makeWrapperArgs = (old.makeWrapperArgs or []) ++ [
        "--prefix"
        "LD_LIBRARY_PATH"
        ":"
        (lib.makeLibraryPath [pkgs.ffmpeg_8])
      ];
    }));
}
