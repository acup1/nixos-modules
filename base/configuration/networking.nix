{...}: {
  imports = [(import ../../lib/package-options.nix "base" [{
    id = "networkmanager";
    definitions = {
      networking.networkmanager.enable = true;
    };
  }])];
}
