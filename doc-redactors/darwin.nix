{lib, pkgs, ...}: let
  cask = import ../lib/darwin-cask.nix lib;
  optIn = entry: entry // {default = false;};
in {
  imports = [
    (import ../lib/component-packages.nix "doc-redactors" "system")
    (import ../lib/darwin-package-options.nix "doc-redactors" (import ./darwin-packages.nix {inherit pkgs;}))
    (import ../lib/package-options.nix "doc-redactors" (map optIn [
      (cask "libreoffice-qt-stable" "libreoffice")
      {id = "pdfarranger"; package = pkgs.pdfarranger or null;}
      {id = "wpsoffice-cn"; package = pkgs.wpsoffice-cn or null;}
      {id = "xournalpp"; package = pkgs.xournalpp or null;}
      {id = "zathura"; package = pkgs.zathura or null;}
    ]))
  ];
}
