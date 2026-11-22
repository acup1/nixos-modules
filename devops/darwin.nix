{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  configuredHome = config.users.users.${username}.home or null;
  homeDirectory = if configuredHome == null then "/Users/${username}" else toString configuredHome;
in {
  imports =
    [(import ../lib/component-packages.nix "devops" "system")]
    ++ lib.filesystem.listFilesRecursive ./packages;

  config = lib.mkIf config.components.devops.enabledPackages.colima {
    launchd.user.agents.colima.serviceConfig = {
      ProgramArguments = [
        "${pkgs.colima}/bin/colima"
        "start"
        "--foreground"
        "--runtime"
        "docker"
        "--vm-type"
        "vz"
        "--mount-type"
        "virtiofs"
      ];
      EnvironmentVariables.HOME = homeDirectory;
      WorkingDirectory = homeDirectory;
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Interactive";
      StandardOutPath = "/tmp/colima.log";
      StandardErrorPath = "/tmp/colima.error.log";
    };
  };
}
