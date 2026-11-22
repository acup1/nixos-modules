{...}: {
  imports = [
    (import ../../lib/package-options.nix "macos-base" [{
      id = "middleclick";
      definitions.homebrew.casks = ["middleclick"];
    }])
  ];

  homebrew.enable = true;
}
