{...}: {
  imports = [
    (import ../lib/named-packages.nix "sound" {names = ["playerctl"];})
    (import ../lib/component-packages.nix "sound" "system")
  ];
}
