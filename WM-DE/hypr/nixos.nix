{lib, ...}: {
  imports =
    [ ../common/nixos.nix ]
    ++ (lib.filesystem.listFilesRecursive ./configuration)
    ++ (lib.filesystem.listFilesRecursive ./packages);
}
