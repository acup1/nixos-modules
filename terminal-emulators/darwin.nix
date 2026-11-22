{
  imports = [./system-module.nix (import ./darwin-fonts.nix "terminal-emulators")];
  components.terminal-emulators.standalone = true;
}
