{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "ru-locale" "system")]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
