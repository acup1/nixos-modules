{pkgs, ...}: [
  {id = "typst"; package = pkgs.typst;}
  {id = "texliveFull"; legacyId = "texlive-full"; package = pkgs.texliveFull;}
  {id = "obsidian"; package = pkgs.obsidian;}
]
