{...}: {
  imports = [
    (import ../lib/component-packages.nix "moonlight" "system")
    (import ../lib/package-options.nix "moonlight" [{
      id = "moonlight";
      definitions = {
        homebrew.casks = ["moonlight"];
      };
    }])
  ];
}
