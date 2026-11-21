{lib, ...}: {
  imports =
    [
      ../common/nixos.nix
      (import ../../lib/component-packages.nix "drift" "system")
    ]
    ++ (lib.filesystem.listFilesRecursive ./configuration);
}
