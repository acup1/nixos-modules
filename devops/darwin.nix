{
  lib,
  pkgs,
  username,
  ...
}: {
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
    EnvironmentVariables.HOME = "/Users/${username}";
    WorkingDirectory = "/Users/${username}";
    RunAtLoad = true;
    KeepAlive = true;
    ProcessType = "Interactive";
    StandardOutPath = "/tmp/colima.log";
    StandardErrorPath = "/tmp/colima.error.log";
  };
}
