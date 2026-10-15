{
  lib,
  pkgs,
  ...
}: let
  yabai = lib.getExe pkgs.yabai;
  jq = lib.getExe pkgs.jq;

  keepLayoutUsable = pkgs.writeShellScript "yabai-keep-layout-usable" ''
    window_id="''${1:-}"
    [ -n "$window_id" ] || exit 0

    # Let the application finish applying its own NSWindow constraints first.
    sleep 0.4

    window="$(${yabai} -m query --windows --window "$window_id" 2>/dev/null)" || exit 0
    is_floating="$(printf '%s' "$window" | ${jq} -r '.["is-floating"]')"

    # Dialogs and application popups must keep their application-provided
    # position and stacking order instead of being inserted into the BSP tree.
    [ "$is_floating" = false ] || exit 0

    space="$(printf '%s' "$window" | ${jq} -r '.space')"
    windows="$(${yabai} -m query --windows --space "$space")" || exit 0

    leaf_count="$(printf '%s' "$windows" | ${jq} '[
      .[]
      | select(
          .["is-floating"] == false
          and .["is-visible"] == true
          and .["has-ax-reference"] == true
          and (.app | test("^(System Settings|System Information|Activity Monitor|Calculator|Finder|Archive Utility)$") | not)
          and (.["stack-index"] == 0 or .["stack-index"] == 1)
        )
    ] | length')"

    overlaps="$(printf '%s' "$windows" | ${jq} --argjson id "$window_id" '
      ([.[] | select(.id == $id)] | first) as $new
      | if $new == null then false else any(
          .[];
          .id != $id
          and .["is-floating"] == false
          and .["is-visible"] == true
          and .["has-ax-reference"] == true
          and ($new.frame.x < (.frame.x + .frame.w))
          and (($new.frame.x + $new.frame.w) > .frame.x)
          and ($new.frame.y < (.frame.y + .frame.h))
          and (($new.frame.y + $new.frame.h) > .frame.y)
        ) end
    ')"

    if [ "$leaf_count" -le 4 ] && [ "$overlaps" != true ]; then
      exit 0
    fi

    target="$(printf '%s' "$windows" | ${jq} -r --argjson id "$window_id" '[
      .[]
      | select(
          .id != $id
          and .["is-floating"] == false
          and .["is-visible"] == true
          and .["has-ax-reference"] == true
          and (.app | test("^(System Settings|System Information|Activity Monitor|Calculator|Finder|Archive Utility)$") | not)
          and (.["stack-index"] == 0 or .["stack-index"] == 1)
        )
    ] | max_by(.frame.w * .frame.h) | .id // empty')"

    [ -n "$target" ] || exit 0
    ${yabai} -m window "$target" --stack "$window_id" || exit 0
    ${yabai} -m space "$space" --balance
  '';
in {
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = false;

    config = {
      layout = "bsp";
      top_padding = 6;
      bottom_padding = 6;
      left_padding = 6;
      right_padding = 6;
      window_gap = 6;

      # App-owned transient menus (notably Telegram reactions) are not exposed
      # as AX windows. Focusing the window underneath them closes the menu.
      focus_follows_mouse = "off";
      mouse_follows_focus = "off";
      mouse_modifier = "cmd";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";

      window_origin_display = "focused";
      window_placement = "second_child";
      split_ratio = 0.5;
      auto_balance = "off";
      window_zoom_persist = "on";
      skip_window_focus_animation = "on";
      insert_feedback_color = "0xffa4e4bf";
    };

    extraConfig = ''
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^System Information$" manage=off
      yabai -m rule --add app="^Activity Monitor$" manage=off
      yabai -m rule --add app="^Calculator$" manage=off
      yabai -m rule --add app="^Finder$" manage=off
      yabai -m rule --add app="^Archive Utility$" manage=off
      yabai -m rule --add role="^AXDialog$" manage=off
      yabai -m rule --add subrole="^AXSystemDialog$" manage=off
      # Telegram's user picker is exposed as a regular secondary AXWindow.
      # Keep every window except the account's main window unmanaged; yabai
      # keeps unmanaged windows above the managed BSP layer until they close.
      yabai -m rule --add label=telegram-popup \
        app="^Telegram$" \
        title!="^Telegram @ .+$" \
        manage=off
      yabai -m rule --add title="^(Picture in Picture|Picture-in-Picture)$" manage=off
      yabai -m rule --apply

      yabai -m signal --add label=keep-layout-usable \
        event=window_created \
        app!="^[Gg]hostty$" \
        action='${keepLayoutUsable} "$YABAI_WINDOW_ID"'

      # Ghostty tabs are exposed to macOS accessibility as separate windows.
      # Rebuild the current BSP tree instead of treating a tab as a new tile.
      yabai -m signal --add label=ghostty-tab-created \
        event=window_created \
        app="^[Gg]hostty$" \
        action='${yabai} -m space --layout bsp'
      yabai -m signal --add label=ghostty-tab-destroyed \
        event=window_destroyed \
        app="^[Gg]hostty$" \
        action='${yabai} -m space --layout bsp'
    '';
  };

  system.defaults = {
    NSGlobalDomain.AppleSpacesSwitchOnActivate = false;
    dock.mru-spaces = false;
    dock.persistent-apps = [ ];
    dock.show-recents = false;
    spaces.spans-displays = false;
    finder.CreateDesktop = true;
    WindowManager = {
      GloballyEnabled = false;
      EnableStandardClickToShowDesktop = false;
      EnableTilingByEdgeDrag = false;
      EnableTopTilingByEdgeDrag = false;
      EnableTilingOptionAccelerator = false;
    };
  };
}
