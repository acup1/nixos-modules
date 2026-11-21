{lib, ...}: {
  imports =
    [
      ../common/home.nix
      (import ../../lib/component-packages.nix "drift" "home")
    ]
    ++ (lib.fileset.toList (
      lib.fileset.fileFilter (file: file.name == "default.nix") ./home_packages
    ));
}
