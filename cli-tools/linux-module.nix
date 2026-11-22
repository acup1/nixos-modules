{config, pkgs, ...}: let
  extra = id: package: {
    inherit id package;
    available = config.components.cli-tools.standalone;
  };
in {
  imports = [
    (import ../terminal/profile.nix "cli-tools" "system")
    (import ../lib/package-options.nix "cli-tools" (with pkgs; [
      {id = "comma"; package = comma;}
      {id = "curl"; package = curl;}
      {id = "watch"; package = watch;}
      {id = "cpupower"; package = linuxKernel.packages.linux_zen.cpupower;}
      {id = "sshfs"; package = sshfs;}
      {id = "cmatrix"; package = cmatrix;}
      {id = "pipes-rs"; package = pipes-rs;}
      (extra "wget" wget)
      (extra "unzip" unzip)
      (extra "fzf" fzf)
      (extra "git" git)
      (extra "bat" bat)
      (extra "zellij" zellij)
      (extra "fastfetch" fastfetch)
      (extra "yq" yq)
      (extra "p7zip" p7zip)
    ]))
  ];
}
