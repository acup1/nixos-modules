{lib, ...}: {
  imports =
    [ ../common/nixos.nix ]
    ++ (lib.filesystem.listFilesRecursive ./configuration);
}
