{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  # repo = builtins.fetchGit { url = "https://github.com/Diolinux/PhotoGIMP"; };
  repo = builtins.fetchGit {
    url = "https://github.com/Diolinux/PhotoGIMP";
    rev = "ee1e453d2238e19469ee71e500a86ef0aae6bb21"; # ← required for pure eval
    # You can also add:
    # ref = "master";  # or a branch/tag if you want
  };
in {
  home.packages = with pkgs; [gimp3];
  #xdg.configFile."waybar".source = ./.config/waybar;

  home.activation.copyPhotoGIMPConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    target=${lib.escapeShellArg "${config.xdg.configHome}/GIMP"}
    if [ -L "$target" ]; then
      run rm "$target"
    fi
    run mkdir -p "$target"
    run cp -rL ${lib.escapeShellArg "${repo.outPath}/.config/GIMP/."} "$target/"
    run chmod -R u+rwX "$target"
  '';
}
