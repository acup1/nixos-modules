{...}: {
  imports = [(import ../../../lib/package-options.nix "niri" [
    {id = "niri"; definitions.programs.niri.enable = true;}
  ])];
}
