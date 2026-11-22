{lib, ...}: {
  imports =
    [
      ../WM-DE/gnome/nixos.nix
      (import ../lib/component-packages.nix "sunshine" "system")
      (import ../lib/package-options.nix "sunshine" [{id = "sunshine";}])
    ]
    ++ (lib.filesystem.listFilesRecursive ./configuration);
}
