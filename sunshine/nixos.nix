{lib, ...}: {
  imports =
    [
      ../WM-DE/gnome/nixos.nix
      (import ../lib/component-packages.nix "sunshine" "system")
    ]
    ++ (lib.filesystem.listFilesRecursive ./configuration);
}
