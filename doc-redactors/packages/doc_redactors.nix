{pkgs, ...}: {
  imports = [(import ../../lib/package-options.nix "doc-redactors" (with pkgs; [
    {id = "libreoffice-qt-stable"; package = libreoffice-qt-stable;}
    {id = "wpsoffice-cn"; package = wpsoffice-cn;}
    {id = "typst"; package = typst;}
    {id = "texliveFull"; package = texliveFull;}
    {id = "xournalpp"; package = xournalpp;}
    {id = "pdfarranger"; package = pdfarranger;}
    {id = "zathura"; package = zathura;}
    {id = "obsidian"; package = obsidian;}
  ]))];
}
