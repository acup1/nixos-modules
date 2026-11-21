{lib, ...}: {
  imports =
    [(import ../lib/component-packages.nix "vscode" "home")]
    ++ (lib.fileset.toList (
      lib.fileset.fileFilter (file: file.name == "default.nix") ./home_packages
    ));
}
