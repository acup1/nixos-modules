{specialArgs, ...}: {
  imports = [
    (if specialArgs ? inputs.nvf
     then import ../../settings.nix specialArgs.inputs.nvf
     else (builtins.getFlake "path:${toString ../..}").homeManagerModules.default)
  ];
}
