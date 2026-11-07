{lib, ...}: {
  imports = lib.filesystem.listFilesRecursive ./configuration;
}
