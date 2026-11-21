{lib, ...}: {
  imports =
    [
      ../common/nixos.nix
      (import ../../lib/component-packages.nix "hypr" "system")
    ]
    ++ (lib.filesystem.listFilesRecursive ./configuration)
    ++ (lib.filesystem.listFilesRecursive ./packages);
}
