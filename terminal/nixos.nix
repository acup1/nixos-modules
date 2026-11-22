{
  imports = [
    ../terminal-emulators/system-module.nix
    ../cli-tools/linux-module.nix
    (import ./compatibility.nix "terminal" "system" [
      {name = "terminal-emulators"; ids = ["alacritty"];}
      {
        name = "cli-tools";
        ids = ["btop" "cava" "yazi" "comma" "curl" "watch" "cpupower" "sshfs" "cmatrix" "pipes-rs"];
      }
    ])
  ];
}
