{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "macos-packages" [
      { id = "typst"; package = pkgs.typst; }
      { id = "texlive-full"; package = pkgs.texliveFull; }
      { id = "obsidian"; package = pkgs.obsidian; }
    ])
  ];
}
