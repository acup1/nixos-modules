{...}: {
  imports = [
    ../common/home.nix
    (import ../../lib/component-packages.nix "gnome" "home")
  ];
}
