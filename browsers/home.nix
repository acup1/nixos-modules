{config, lib, options, pkgs, ...}: let
  names = ["chrome" "zen"];
  cfg = config.components.browsers.mcp;
  enabled = lib.filter (name: cfg.${name}.enable) names;
  darwin = pkgs.stdenv.hostPlatform.isDarwin;
  executables = {
    chrome = if darwin then "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" else "google-chrome-stable";
    zen = if darwin then "/Applications/Nix Apps/Zen Browser (Beta).app/Contents/MacOS/zen" else "zen";
  };
  python = pkgs.python3.withPackages (ps: [(ps.mcp_1 or ps.mcp) ps.websocket-client]);
  chromeDevTools = let
    version = "1.14.0";
    source = pkgs.fetchurl {
      url = "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-${version}.tgz";
      hash = "sha256-bC6yvfxN0O12KAT+CGibjcIXu5NaWD4CN8nMNHzez4o=";
    };
  in
    pkgs.runCommand "chrome-devtools-mcp-${version}" {} ''
      mkdir -p "$out"
      tar -xzf ${source} -C "$out" --strip-components=1
    '';
  browserOptions = name: {
    enable = lib.mkEnableOption "local browser automation MCP for ${name}";
    port = lib.mkOption {
      type = lib.types.ints.between 1024 65535;
      default = if name == "chrome" then 9222 else 9223;
      description = "Loopback port for the browser's remote debugging endpoint.";
    };
    executable = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = executables.${name};
      description = "Browser executable path or command in PATH.";
    };
    profileDirectory = lib.mkOption {
      type = lib.types.strMatching "/.+";
      default = "${config.xdg.stateHome}/browser-mcp/${name}";
      defaultText = lib.literalExpression ''"''${config.xdg.stateHome}/browser-mcp/${name}"'';
      description = "Absolute path to a dedicated browser profile for MCP.";
    };
  };
  launchers = {
    chrome = let
      settings = cfg.chrome;
      browserArgs = [
        "--remote-debugging-address=127.0.0.1"
        "--remote-debugging-port=${toString settings.port}"
        "--user-data-dir=${settings.profileDirectory}"
        "--no-first-run"
      ];
    in pkgs.writeShellScriptBin "chrome-mcp-browser" ''
      umask 077
      mkdir -p -- ${lib.escapeShellArg settings.profileDirectory}
      exec ${lib.escapeShellArg settings.executable} ${lib.escapeShellArgs browserArgs}
    '';
    zen = let
      settings = cfg.zen;
    in pkgs.writeShellScriptBin "zen-mcp-browser" ''
      if [ "$#" -eq 0 ]; then
        umask 077
        mkdir -p -- ${lib.escapeShellArg settings.profileDirectory} || exit
        set -- --profile ${lib.escapeShellArg settings.profileDirectory}
      elif [ "$#" -eq 1 ] && [ "$1" = --default-profile ]; then
        set --
      else
        echo 'Usage: zen-mcp-browser [--default-profile]' >&2
        exit 2
      fi

      exec ${lib.escapeShellArg settings.executable} --no-remote --remote-debugging-port ${toString settings.port} "$@"
    '';
  };
  servers = {
    chrome = pkgs.writeShellScriptBin "chrome-mcp" ''
      export CHROME_DEVTOOLS_MCP_NO_UPDATE_CHECKS=1
      exec ${lib.getExe pkgs.nodejs} ${chromeDevTools}/out/Default/gen/src/bin/chrome-devtools-mcp.js \
        --browser-url http://127.0.0.1:${toString cfg.chrome.port} \
        --no-usage-statistics --no-performance-crux
    '';
    zen = pkgs.writeShellScriptBin "zen-mcp" ''
      exec ${python}/bin/python ${./browser-mcp}/server.py ${toString cfg.zen.port}
    '';
  };
in {
  options.components.browsers.mcp = lib.genAttrs names browserOptions;

  config = lib.mkIf (enabled != []) ({
    assertions = [
      {
        assertion = !(cfg.chrome.enable && cfg.zen.enable) || cfg.chrome.port != cfg.zen.port;
        message = "Chrome and Zen MCP require distinct loopback ports.";
      }
      {
        assertion = !(cfg.chrome.enable && cfg.zen.enable) || cfg.chrome.profileDirectory != cfg.zen.profileDirectory;
        message = "Chrome and Zen MCP require distinct profile directories.";
      }
    ];
    home.packages = map (name: launchers.${name}) enabled ++ map (name: servers.${name}) enabled;
  } // lib.optionalAttrs (options ? programs.mcp.servers) {
    programs.mcp = {
      enable = true;
      servers = lib.genAttrs enabled (name: {
        command = lib.getExe' servers.${name} "${name}-mcp";
      });
    };
  });
}
