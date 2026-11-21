{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "sunshine" "home")]
    ++ (lib.fileset.toList (
      lib.fileset.fileFilter (file: file.name == "default.nix") ./home_packages
    ));
}
