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
    target="$HOME/.config/GIMP"
    if [ -L "$target" ]; then
      rm "$target"
    fi
    mkdir -p "$target"
    cp -rL ${lib.escapeShellArg "${repo.outPath}/.config/GIMP/."} "$target/"
    chmod -R u+rwX "$target"
  '';
}
