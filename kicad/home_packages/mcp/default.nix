{config, lib, options, pkgs, ...}: let
  cfg = config.components.kicad.mcp;
  hasMcpRegistry = options ? programs.mcp.enable && options ? programs.mcp.servers;
  kicad = pkgs.kicad or null;
  defaultCli =
    if pkgs.stdenv.hostPlatform.isLinux && kicad != null
      && lib.meta.availableOn pkgs.stdenv.hostPlatform kicad
      && !(kicad.meta.broken or false)
    then lib.getExe' kicad "kicad-cli"
    else null;
  cli = if cfg.cliExecutable != null then cfg.cliExecutable else defaultCli;
  python = pkgs.python3.withPackages (p: [ (p.mcp_1 or p.mcp) ]);
  darwinCli = "/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli";
  server = pkgs.writeShellApplication {
    name = "kicad-mcp";
    text = ''
      cliArgs=()
      ${if cli != null
        then "cliArgs=(--kicad-cli ${lib.escapeShellArg cli})"
        else lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
          if [ -x ${lib.escapeShellArg darwinCli} ]; then
            cliArgs=(--kicad-cli ${lib.escapeShellArg darwinCli})
          fi
        ''}
      exec ${python}/bin/python3 ${./server.py} "''${cliArgs[@]}" "$@"
    '';
  };
in {
  options.components.kicad.mcp = {
    enable = lib.mkEnableOption "the KiCad stdio MCP provider";

    projectsDirectory = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Absolute root of the KiCad project tree. The client's working directory is used by default.";
    };

    cliExecutable = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Absolute path to kicad-cli. Defaults to the Nixpkgs package on Linux or the KiCad app in /Applications on macOS.";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [{
    assertions = [
      {
        assertion = cfg.projectsDirectory == null || lib.hasPrefix "/" cfg.projectsDirectory;
        message = "components.kicad.mcp.projectsDirectory must be an absolute path.";
      }
      {
        assertion = cfg.cliExecutable == null || lib.hasPrefix "/" cfg.cliExecutable;
        message = "components.kicad.mcp.cliExecutable must be an absolute path.";
      }
    ];

    components.kicad.packages = [server];
  } (lib.optionalAttrs hasMcpRegistry {
    programs.mcp.enable = true;
    programs.mcp.servers.kicad = {
      command = lib.getExe server;
      args = lib.optionals (cfg.projectsDirectory != null) ["--root" cfg.projectsDirectory];
    };
  })]);
}
