{lib, ...}: {
  imports =
    [ ../WM-DE/gnome/nixos.nix ]
    ++ (lib.filesystem.listFilesRecursive ./configuration);
}
