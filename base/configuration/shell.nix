{config, lib, ...}: {
  config = lib.mkIf config.components.base.enabledPackages.zsh {
    programs.zsh.enable = true;
  };
}
