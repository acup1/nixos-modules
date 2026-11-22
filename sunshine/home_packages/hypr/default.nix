{lib, pkgs, ...}: {
  imports = [(import ../../../lib/package-options.nix "sunshine" [{
    id = "sunshine";
    available = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.sunshine;
    definitions.wayland.windowManager.hyprland = {
      configType = "lua";
      extraConfig = lib.mkAfter (builtins.readFile ./.config/hypr/sunshine.lua);
    };
  }])];
}
