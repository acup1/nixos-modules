{
  config,
  lib,
  pkgs,
  ...
}: let
  yabai = lib.getExe pkgs.yabai;
  jq = lib.getExe pkgs.jq;
  skhd = lib.getExe pkgs.skhd;
  ghosttyApp = "${config.home.homeDirectory}/Applications/Home Manager Apps/Ghostty.app";

  closeWindowUnderMouse = pkgs.writeShellScript "yabai-close-window-under-mouse" ''
    target="$(${yabai} -m query --windows --window mouse 2>/dev/null)" || exit 0
    target_id="$(printf '%s' "$target" | ${jq} -r '.id // empty')"
    original_space="$(printf '%s' "$target" | ${jq} -r '.space // empty')"

    [ -n "$target_id" ] && [ -n "$original_space" ] || exit 0

    # Keep an application from this space active while the target is closed.
    # Otherwise macOS may activate the previous application on another space.
    fallback_id="$(${yabai} -m query --windows --space "$original_space" 2>/dev/null | ${jq} -r --argjson target "$target_id" '
      [
        .[]
        | select(
            .id != $target
            and .["has-ax-reference"] == true
            and .["is-minimized"] == false
          )
      ]
      | sort_by(if .["is-visible"] then 0 else 1 end)
      | first
      | .id // empty
    ')"

    if [ -n "$fallback_id" ]; then
      ${yabai} -m window "$fallback_id" --focus
      /bin/sleep 0.05
    fi

    ${yabai} -m window "$target_id" --close || exit 0

    # macOS can activate another window on a different space after a close.
    # Keep restoring the original space until that activation has settled.
    for _ in 1 2 3 4 5; do
      /bin/sleep 0.1
      current_space="$(${yabai} -m query --spaces --space 2>/dev/null | ${jq} -r '.index // empty')"
      if [ -n "$current_space" ] && [ "$current_space" != "$original_space" ]; then
        ${yabai} -m space --focus "$original_space"
      fi
    done

    hovered="$(${yabai} -m query --windows --window mouse 2>/dev/null)" || exit 0
    hovered_id="$(printf '%s' "$hovered" | ${jq} -r '.id // empty')"
    hovered_space="$(printf '%s' "$hovered" | ${jq} -r '.space // empty')"

    if [ -n "$hovered_id" ] && [ "$hovered_space" = "$original_space" ]; then
      ${yabai} -m window "$hovered_id" --focus
    fi
  '';

  focusOtherLayout = pkgs.writeShellScript "yabai-focus-other-layout" ''
    focused="$(${yabai} -m query --windows --window 2>/dev/null)" || exit 0
    is_floating="$(printf '%s' "$focused" | ${jq} -r '.["is-floating"]')"

    if [ "$is_floating" = true ]; then
      target="$(${yabai} -m query --windows --space | ${jq} -r 'map(select(.["is-floating"] == false and .["is-visible"] == true)) | first | .id // empty')"
    else
      target="$(${yabai} -m query --windows --space | ${jq} -r 'map(select(.["is-floating"] == true and .["is-visible"] == true)) | first | .id // empty')"
    fi

    [ -n "$target" ] && ${yabai} -m window --focus "$target"
  '';

  hotkeyHelp = pkgs.writeShellScript "yabai-hotkeys" ''
    /usr/bin/osascript -e 'display dialog "Mod (physical Option)" & return & return & "Arrows: focus" & return & "Ctrl + H/J/K/L or arrows: move" & return & "1..9: space" & return & "Shift + 1..9: move to space" & return & "Page Down/Page Up: next/previous space" & return & "F: maximize" & return & "V: floating/tiling" with title "yabai shortcuts" buttons {"OK"} default button "OK"'
  '';
in {
  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    config = ''
      # Focus windows with arrows. Letter bindings are left to applications.
      lcmd - left  : ${yabai} -m window --focus west
      lcmd - down  : ${yabai} -m window --focus south
      lcmd - up    : ${yabai} -m window --focus north
      lcmd - right : ${yabai} -m window --focus east
      lcmd - home  : ${yabai} -m window --focus first
      lcmd - end   : ${yabai} -m window --focus last

      # Move windows in the BSP tree.
      lcmd + ctrl - h     : ${yabai} -m window --warp west
      lcmd + ctrl - j     : ${yabai} -m window --warp south
      lcmd + ctrl - k     : ${yabai} -m window --warp north
      lcmd + ctrl - l     : ${yabai} -m window --warp east
      lcmd + ctrl - left  : ${yabai} -m window --warp west
      lcmd + ctrl - down  : ${yabai} -m window --warp south
      lcmd + ctrl - up    : ${yabai} -m window --warp north
      lcmd + ctrl - right : ${yabai} -m window --warp east
      lcmd + ctrl - home  : ${yabai} -m window --swap first
      lcmd + ctrl - end   : ${yabai} -m window --swap last

      # Displays. K/L stay reserved for volume, as in the Niri config.
      lcmd + shift - h     : ${yabai} -m display --focus west
      lcmd + shift - j     : ${yabai} -m display --focus south
      lcmd + shift - left  : ${yabai} -m display --focus west
      lcmd + shift - down  : ${yabai} -m display --focus south
      lcmd + shift - up    : ${yabai} -m display --focus north
      lcmd + shift - right : ${yabai} -m display --focus east

      lcmd + ctrl + shift - h     : ${yabai} -m window --display west  && ${yabai} -m display --focus west
      lcmd + ctrl + shift - j     : ${yabai} -m window --display south && ${yabai} -m display --focus south
      lcmd + ctrl + shift - k     : ${yabai} -m window --display north && ${yabai} -m display --focus north
      lcmd + ctrl + shift - l     : ${yabai} -m window --display east  && ${yabai} -m display --focus east
      lcmd + ctrl + shift - left  : ${yabai} -m window --display west  && ${yabai} -m display --focus west
      lcmd + ctrl + shift - down  : ${yabai} -m window --display south && ${yabai} -m display --focus south
      lcmd + ctrl + shift - up    : ${yabai} -m window --display north && ${yabai} -m display --focus north
      lcmd + ctrl + shift - right : ${yabai} -m window --display east  && ${yabai} -m display --focus east

      # Spaces 1 through 9.
      lcmd - 1 : ${yabai} -m space --focus 1
      lcmd - 2 : ${yabai} -m space --focus 2
      lcmd - 3 : ${yabai} -m space --focus 3
      lcmd - 4 : ${yabai} -m space --focus 4
      lcmd - 5 : ${yabai} -m space --focus 5
      lcmd - 6 : ${yabai} -m space --focus 6
      lcmd - 7 : ${yabai} -m space --focus 7
      lcmd - 8 : ${yabai} -m space --focus 8
      lcmd - 9 : ${yabai} -m space --focus 9

      lcmd + shift - 1 : ${yabai} -m window --space 1 && ${yabai} -m space --focus 1
      lcmd + shift - 2 : ${yabai} -m window --space 2 && ${yabai} -m space --focus 2
      lcmd + shift - 3 : ${yabai} -m window --space 3 && ${yabai} -m space --focus 3
      lcmd + shift - 4 : ${yabai} -m window --space 4 && ${yabai} -m space --focus 4
      lcmd + shift - 5 : ${yabai} -m window --space 5 && ${yabai} -m space --focus 5
      lcmd + shift - 6 : ${yabai} -m window --space 6 && ${yabai} -m space --focus 6
      lcmd + shift - 7 : ${yabai} -m window --space 7 && ${yabai} -m space --focus 7
      lcmd + shift - 8 : ${yabai} -m window --space 8 && ${yabai} -m space --focus 8
      lcmd + shift - 9 : ${yabai} -m window --space 9 && ${yabai} -m space --focus 9

      lcmd - u         : /usr/bin/open '/System/Applications/Utilities/Screenshot.app'
      lcmd - i         : ${yabai} -m space --focus prev
      lcmd - pagedown : ${yabai} -m space --focus next
      lcmd - pageup   : ${yabai} -m space --focus prev

      lcmd + ctrl - u         : ${yabai} -m window --space next && ${yabai} -m space --focus next
      lcmd + ctrl - i         : ${yabai} -m window --space prev && ${yabai} -m space --focus prev
      lcmd + ctrl - pagedown : ${yabai} -m window --space next && ${yabai} -m space --focus next
      lcmd + ctrl - pageup   : ${yabai} -m window --space prev && ${yabai} -m space --focus prev

      # Grouping, sizing and layouts.
      lcmd - 0x1B         : ${yabai} -m window --resize left:50:0  || ${yabai} -m window --resize right:-50:0
      lcmd - 0x18         : ${yabai} -m window --resize left:-50:0 || ${yabai} -m window --resize right:50:0
      lcmd + shift - 0x1B : ${yabai} -m window --resize top:0:50  || ${yabai} -m window --resize bottom:0:-50
      lcmd + shift - 0x18 : ${yabai} -m window --resize top:0:-50 || ${yabai} -m window --resize bottom:0:50
      lcmd - r [
        "zen" ~
        * : ${yabai} -m window --ratio abs:0.50
      ]
      lcmd + shift - r    : ${yabai} -m window --ratio abs:0.66
      lcmd + ctrl - r     : ${yabai} -m space --balance
      lcmd - f            : ${yabai} -m window --toggle zoom-parent
      lcmd + ctrl - f     : ${yabai} -m window --toggle zoom-parent
      lcmd + shift - f    : ${yabai} -m window --toggle zoom-fullscreen
      f14                : ${yabai} -m window --toggle float
      lcmd + shift - v    : ${focusOtherLayout}
      lcmd - 0x21 : ${yabai} -m window --stack west
      lcmd - 0x1E : ${yabai} -m window --stack east
      lcmd - 0x2B : ${yabai} -m window --stack east
      lcmd - 0x2F : ${yabai} -m window --warp east

      # Applications and system actions.
      f13          : ${closeWindowUnderMouse}
      lcmd - q      : /usr/bin/open -na '${ghosttyApp}'
      lcmd - x      : ${skhd} -k 'f19'
      lcmd - o      : /usr/bin/open '/System/Applications/Mission Control.app'
      lcmd + shift - k : osascript -e 'set currentVolume to output volume of (get volume settings)' -e 'set volume output volume (currentVolume - 5)'
      lcmd + shift - l : osascript -e 'set currentVolume to output volume of (get volume settings)' -e 'set volume output volume (currentVolume + 5)'
      lcmd + shift - 0x2C : ${hotkeyHelp}

    '';
  };
}
