# A package switch controls both the cask and its Homebrew integration.
lib: id: name: {
  inherit id;
  definitions.homebrew = {
    enable = lib.mkDefault true;
    casks = [name];
  };
}
