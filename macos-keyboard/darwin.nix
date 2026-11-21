{...}: {
  imports = [(import ../lib/component-packages.nix "macos-keyboard" "system")];

  homebrew.casks = ["karabiner-elements"];

  system.defaults.CustomUserPreferences."com.apple.HIToolbox" = {
    # Do not switch the input source when Fn/Globe is pressed alone.
    AppleFnUsageType = 0;
  };
}
