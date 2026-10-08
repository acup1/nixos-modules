{lib, ...}: {
  imports =
    (lib.filesystem.listFilesRecursive ./configuration)
    ++ (lib.filesystem.listFilesRecursive ./packages);
}

