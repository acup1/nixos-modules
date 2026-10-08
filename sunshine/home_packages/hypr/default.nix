{lib, ...}: {
  wayland.windowManager.hyprland = {
    configType = "lua";
    extraConfig = lib.mkAfter (builtins.readFile ./.config/hypr/sunshine.lua);
  };
}
