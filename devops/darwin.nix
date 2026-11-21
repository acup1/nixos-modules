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
  imports = lib.filesystem.listFilesRecursive ./packages;

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
}
