{config, lib, options, pkgs, ...}: let
  cfg = config.components.wireshark;
  python = pkgs.python3.withPackages (ps: [(ps.mcp_1 or ps.mcp)]);
  dumpcap =
    if pkgs.stdenv.hostPlatform.isLinux
    then "/run/wrappers/bin/dumpcap"
    else "${pkgs.wireshark-cli}/bin/dumpcap";
  server = pkgs.writeShellScriptBin "wireshark-mcp" ''
    export WIRESHARK_BIN=${pkgs.wireshark-cli}/bin
    ${lib.optionalString (cfg.mcp.captureDirectory != "") ''
      export WIRESHARK_MCP_ROOT=${lib.escapeShellArg cfg.mcp.captureDirectory}
    ''}
    ${lib.optionalString cfg.mcp.liveCapture.enable ''
      export WIRESHARK_MCP_DUMPCAP=${lib.escapeShellArg dumpcap}
      export WIRESHARK_MCP_INTERFACE=${lib.escapeShellArg cfg.mcp.liveCapture.interface}
    ''}
    exec ${python}/bin/python ${./server.py} "$@"
  '';
in {
  imports = [(import ../lib/package-options.nix "wireshark" [{id = "wireshark";}])];
  options.components.wireshark.mcp = {
    enable = lib.mkEnableOption "the local Wireshark capture-file analysis MCP server";
    captureDirectory = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Directory containing captures. An empty value uses the MCP client's working directory.";
    };
    liveCapture = {
      enable = lib.mkEnableOption "explicit packet captures with dumpcap through the Wireshark MCP";
      interface = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Default capture interface. An empty value requires specifying the interface for each capture.";
      };
    };
  };
  config = lib.mkIf (cfg.enabledPackages.wireshark && cfg.mcp.enable && lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.wireshark-cli) ({
    home.packages = [server];
  } // lib.optionalAttrs (options ? programs.mcp.servers) {
    programs.mcp = {
      enable = true;
      servers.wireshark = {
        command = lib.getExe' server "wireshark-mcp";
      };
    };
  });
}
