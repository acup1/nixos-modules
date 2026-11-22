{lib, ...}: {
  imports = [
    (import ../lib/component-packages.nix "kicad" "system")
    (import ../lib/package-options.nix "kicad" [{
      id = "kicad";
      default = false;
      description = "Manage the official KiCad macOS app through Homebrew.";
      definitions.homebrew = {
        enable = lib.mkDefault true;
        casks = ["kicad"];
      };
    }])
  ];
}
