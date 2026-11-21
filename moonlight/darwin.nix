{...}: {
  imports = [(import ../lib/component-packages.nix "moonlight" "system")];

  homebrew.casks = ["moonlight"];
}
