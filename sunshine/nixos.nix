{lib, ...}: {
  imports =
    [
      (import ../lib/component-packages.nix "sunshine" "system")
      (import ../lib/package-options.nix "sunshine" [{id = "sunshine";}])
    ]
    ++ lib.filesystem.listFilesRecursive ./configuration;
}
