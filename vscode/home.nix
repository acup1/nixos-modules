{lib, ...}: {
  imports =
    [
      (import ../lib/component-packages.nix "vscode" "home")
      (import ../lib/package-options.nix "vscode" [{id = "vscode";}])
    ]
    ++ (lib.fileset.toList (
      lib.fileset.fileFilter (file: file.name == "default.nix") ./home_packages
    ));
}
