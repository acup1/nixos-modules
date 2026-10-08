{lib, ...}: {
  imports =
    [ ../common/home.nix ]
    ++ (lib.fileset.toList (
      lib.fileset.fileFilter (file: file.name == "default.nix") ./home_packages
    ));
}
