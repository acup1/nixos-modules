{lib, ...}: {
  imports =
    lib.filesystem.listFilesRecursive ./packages;
}
