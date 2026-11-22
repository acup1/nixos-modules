{pkgs, ...}: {
  imports = [
    (import ../../lib/package-options.nix "macos-packages" [
      { id = "wget"; package = pkgs.wget; }
      { id = "curl"; package = pkgs.curl; }
      { id = "watch"; package = pkgs.watch; }
      { id = "unzip"; package = pkgs.unzip; }
      { id = "fzf"; package = pkgs.fzf; }
      { id = "zsh"; package = pkgs.zsh; }
      { id = "git"; package = pkgs.git; }
      { id = "sshfs"; package = pkgs.sshfs; }
      { id = "bat"; package = pkgs.bat; }
      { id = "zellij"; package = pkgs.zellij; }
      { id = "fastfetch"; package = pkgs.fastfetch; }
      { id = "cmatrix"; package = pkgs.cmatrix; }
      { id = "pipes-rs"; package = pkgs.pipes-rs; }
      { id = "comma"; package = pkgs.comma; }
      { id = "yq"; package = pkgs.yq; }
    ])
  ];
}
