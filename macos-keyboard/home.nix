{
  lib,
  pkgs,
  ...
}: let
  shortcutOptionalModifiers = [
    "caps_lock"
    "left_shift"
    "right_shift"
  ];

  modification = from: to: {
    from.key_code = from;
    to = [{key_code = to;}];
  };

  terminalBundleIdentifiers = [
    "^com\\.apple\\.Terminal$"
    "^com\\.github\\.wez\\.wezterm$"
    "^com\\.googlecode\\.iterm2$"
    "^com\\.mitchellh\\.ghostty$"
    "^net\\.kovidgoyal\\.kitty$"
    "^org\\.alacritty$"
    "^org\\.wezfurlong\\.wezterm$"
  ];

  graphicalApplication = {
    type = "frontmost_application_unless";
    bundle_identifiers = terminalBundleIdentifiers;
  };

  russianInputSource = {
    type = "input_source_if";
    input_sources = [{input_source_id = "^com\\.apple\\.keylayout\\.Russian$";}];
  };

  linuxShortcut = key: {
    type = "basic";
    from = {
      key_code = key;
      modifiers = {
        mandatory = ["left_control"];
        optional = shortcutOptionalModifiers;
      };
    };
    to = [{
      key_code = key;
      modifiers = ["right_command"];
    }];
    conditions = [graphicalApplication];
  };

  modifiedKey = fromKey: fromModifiers: toKey: toModifiers: condition: {
    type = "basic";
    from = {
      key_code = fromKey;
      modifiers = {
        mandatory = fromModifiers;
        optional = builtins.filter
          (modifier: !(builtins.elem modifier fromModifiers))
          shortcutOptionalModifiers;
      };
    };
    to = [{
      key_code = toKey;
      modifiers = toModifiers;
    }];
    conditions = [condition];
  };

  tilingSignal = fromKey: toKey: {
    type = "basic";
    from = {
      key_code = fromKey;
      modifiers = {
        mandatory = ["left_command"];
        optional = ["caps_lock"];
      };
    };
    to = [{key_code = toKey;}];
  };

  linuxShortcutKeys = [
    "0"
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
    "a"
    "b"
    "c"
    "d"
    "f"
    "g"
    "i"
    "k"
    "l"
    "n"
    "o"
    "p"
    "q"
    "r"
    "s"
    "t"
    "v"
    "w"
    "z"
    "comma"
    "equal_sign"
    "hyphen"
    "slash"
  ];

  karabinerConfig = pkgs.writeText "karabiner.json" (builtins.toJSON {
    global = {
      check_for_updates_on_startup = false;
      show_in_menu_bar = true;
      show_profile_name_in_menu_bar = false;
    };

    profiles = [
      {
        name = "macOS keyboard";
        selected = true;

        simple_modifications = [
          (modification "fn" "left_control")
          (modification "left_control" "fn")

          (modification "left_option" "left_command")
          (modification "left_command" "left_option")
          (modification "right_option" "right_command")
          (modification "right_command" "right_option")

          (modification "caps_lock" "vk_none")
        ];

        complex_modifications = {
          parameters = {
            "basic.to_if_alone_timeout_milliseconds" = 1000;
            "basic.to_if_held_down_threshold_milliseconds" = 500;
          };
          rules = [
            {
              description = "Send dedicated signals for Mod+C and Mod+V";
              manipulators = [
                (tilingSignal "c" "f13")
                (tilingSignal "v" "f14")
              ];
            }
            {
              description = "Put Yo on the tilde key in the Russian layout";
              manipulators = [
                {
                  type = "basic";
                  from = {
                    key_code = "grave_accent_and_tilde";
                    modifiers.optional = ["any"];
                  };
                  to = [{key_code = "backslash";}];
                  conditions = [russianInputSource];
                }
              ];
            }
            {
              description = "Linux Ctrl shortcuts in graphical applications";
              manipulators =
                (map linuxShortcut linuxShortcutKeys)
                ++ [
                  # Linux uses Ctrl+Y for redo; macOS applications use Cmd+Shift+Z.
                  (modifiedKey "y" ["left_control"] "z" ["right_command" "left_shift"] graphicalApplication)
                ];
            }
            {
              description = "Linux text navigation in graphical applications";
              manipulators = [
                (modifiedKey "left_arrow" ["left_control"] "left_arrow" ["left_option"] graphicalApplication)
                (modifiedKey "right_arrow" ["left_control"] "right_arrow" ["left_option"] graphicalApplication)
                (modifiedKey "delete_or_backspace" ["left_control"] "delete_or_backspace" ["left_option"] graphicalApplication)
                (modifiedKey "delete_forward" ["left_control"] "delete_forward" ["left_option"] graphicalApplication)
                (modifiedKey "home" ["left_control"] "up_arrow" ["right_command"] graphicalApplication)
                (modifiedKey "end" ["left_control"] "down_arrow" ["right_command"] graphicalApplication)
                (modifiedKey "home" [] "left_arrow" ["right_command"] graphicalApplication)
                (modifiedKey "end" [] "right_arrow" ["right_command"] graphicalApplication)
              ];
            }
          ];
        };

        virtual_hid_keyboard = {
          keyboard_type_v2 = "ansi";
        };
      }
    ];
  });
in {
  home.activation.disableMacOSInputSourceShortcuts = lib.hm.dag.entryAfter ["writeBoundary"] ''
    symbolic_hotkeys="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"

    $DRY_RUN_CMD /usr/bin/defaults write com.apple.HIToolbox AppleFnUsageType -int 0

    if [[ -f "$symbolic_hotkeys" ]]; then
      $DRY_RUN_CMD /usr/bin/killall cfprefsd 2>/dev/null || true

      if /usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:61:enabled" "$symbolic_hotkeys" >/dev/null 2>&1; then
        $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:61:enabled false" "$symbolic_hotkeys"
      fi

      # Mod+Space emits the otherwise unused F18 key through skhd.
      if /usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:60" "$symbolic_hotkeys" >/dev/null 2>&1; then
        $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:60:enabled true" "$symbolic_hotkeys"
        $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:60:value:parameters:0 65535" "$symbolic_hotkeys"
        $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:60:value:parameters:1 79" "$symbolic_hotkeys"
        $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:60:value:parameters:2 0" "$symbolic_hotkeys"
      fi

      # Keep Spotlight away from normal Linux-style shortcuts. Mod+X emits
      # this otherwise unused virtual F19 key through skhd.
      if /usr/libexec/PlistBuddy -c "Print :AppleSymbolicHotKeys:64" "$symbolic_hotkeys" >/dev/null 2>&1; then
        $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled true" "$symbolic_hotkeys"
        $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:value:parameters:0 65535" "$symbolic_hotkeys"
        $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:value:parameters:1 80" "$symbolic_hotkeys"
        $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:value:parameters:2 0" "$symbolic_hotkeys"
      fi

      $DRY_RUN_CMD /usr/bin/killall cfprefsd 2>/dev/null || true
      $DRY_RUN_CMD /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    fi
  '';

  home.activation.installKarabinerConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD install -d -m 700 "$HOME/.config/karabiner"
    $DRY_RUN_CMD install -m 600 ${karabinerConfig} "$HOME/.config/karabiner/karabiner.json"
  '';
}
