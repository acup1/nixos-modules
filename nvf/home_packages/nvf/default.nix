{specialArgs, ...}: {
  imports = [
    (import ../../../lib/package-options.nix "nvf" [{id = "neovim";}])
    (if specialArgs ? inputs.nvf
     then import ../../settings.nix specialArgs.inputs.nvf
     else (builtins.getFlake "path:${toString ../..}").homeManagerModules.default)
  ];
}
