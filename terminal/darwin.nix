{...}: {
  imports = [
    (import ../terminal-emulators/darwin-fonts.nix "terminal")
    (import ../lib/named-packages.nix "terminal" {names = ["alacritty" "cmatrix" "comma" "curl" "pipes-rs" "sshfs" "watch"]; default = false;})
    (import ../lib/component-packages.nix "terminal" "system")
  ];
}
