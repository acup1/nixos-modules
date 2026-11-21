{lib, ...}: {
  imports =
    [
      ../common/nixos.nix
      (import ../../lib/component-packages.nix "gnome" "system")
    ]
    ++ (lib.filesystem.listFilesRecursive ./configuration)
    ++ (lib.filesystem.listFilesRecursive ./packages);
}
