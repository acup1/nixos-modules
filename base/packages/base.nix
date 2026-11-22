{pkgs, ...}: {
  imports = [(import ../../lib/package-options.nix "base" (with pkgs; [
    {id = "git"; package = git;}
    {id = "wget"; package = wget;}
    {id = "unzip"; package = unzip;}
    {id = "p7zip"; package = p7zip;}
    {id = "fzf"; package = fzf;}
    {id = "bat"; package = bat;}
    {id = "neovim"; package = neovim;}
    {id = "fastfetch"; package = fastfetch;}
    {id = "usbutils"; package = usbutils;}
    {id = "zsh"; package = zsh;}
  ]))];
}
