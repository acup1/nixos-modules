{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  supported = import ../../../lib/package-supported.nix pkgs;
  # repo = builtins.fetchGit { url = "https://github.com/Diolinux/PhotoGIMP"; };
  repo = builtins.fetchGit {
    url = "https://github.com/Diolinux/PhotoGIMP";
    rev = "ee1e453d2238e19469ee71e500a86ef0aae6bb21"; # ← required for pure eval
    # You can also add:
    # ref = "master";  # or a branch/tag if you want
  };
  macPatch = pkgs.fetchurl {
    url = "https://github.com/Diolinux/PhotoGIMP/releases/download/3.1/PhotoGIMP.zip";
    hash = "sha256-3moX/7cAAAUTcthBQbfmn8LmCgrzvTsxAMmv1eD/OuY=";
  };
  macConfig = pkgs.runCommand "photo-gimp-macos-config" {
    nativeBuildInputs = [pkgs.unzip];
  } ''
    unzip -q ${macPatch} -d "$out"
  '';
  linuxActivation = ''
    target=${lib.escapeShellArg "${config.xdg.configHome}/GIMP"}
    if [ -L "$target" ]; then
      run rm "$target"
    fi
    run mkdir -p "$target"
    run cp -rL ${lib.escapeShellArg "${repo.outPath}/.config/GIMP/."} "$target/"
    run chmod -R u+rwX "$target"
  '';
  darwinActivation = ''
    target=${lib.escapeShellArg "${config.home.homeDirectory}/Library/Application Support/GIMP"}
    for version in 3.0 3.2; do
      if [ -L "$target" ] || [ -L "$target/$version" ]; then
        echo "PhotoGIMP skipped the symlink at $target/$version." >&2
        continue
      fi
      run mkdir -p "$target/$version"
      run ${lib.getExe pkgs.rsync} -r --ignore-times --chmod=u+rwX ${macConfig}/3.0/ "$target/$version/"
    done
  '';
in {
  imports = [
    (import ../../../lib/package-options.nix "photoGIMP" [{
      id = "gimp3";
      default = isLinux;
      available = isLinux;
      package = pkgs.gimp3;
    }])
  ];

  config.home.activation.copyPhotoGIMPConfig = lib.mkIf (
    config.components.photoGIMP.enabledPackages.gimp3
    && (isDarwin || (isLinux && supported pkgs.gimp3))
  ) (lib.hm.dag.entryAfter ["writeBoundary"] (
    if isDarwin then darwinActivation else linuxActivation
  ));
}
