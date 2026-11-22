{lib, pkgs, ...}: {
  imports =
    [
      (import ../lib/component-packages.nix "vscode" "home")
      (import ../lib/package-options.nix "vscode" [
        {id = "vscode";}
        {id = "vim";}
        {
          id = "codex";
          default = pkgs.stdenv.hostPlatform.system == "aarch64-darwin";
        }
        {id = "local-colorways";}
      ])
    ]
    ++ (lib.fileset.toList (
      lib.fileset.fileFilter (file: file.name == "default.nix") ./home_packages
    ));
}
