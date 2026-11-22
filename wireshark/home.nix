{config, lib, options, pkgs, ...}: let
  cfg = config.components.wireshark;
  python = pkgs.python3.withPackages (ps: [(ps.mcp_1 or ps.mcp)]);
  server = pkgs.writeShellScriptBin "wireshark-mcp" ''
    export WIRESHARK_BIN=${pkgs.wireshark-cli}/bin
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
  };
  config = lib.mkIf (cfg.enabledPackages.wireshark && cfg.mcp.enable && lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.wireshark-cli) ({
    home.packages = [server];
  } // lib.optionalAttrs (options ? programs.mcp.servers) {
    programs.mcp = {
      enable = true;
      servers.wireshark = {
        command = lib.getExe' server "wireshark-mcp";
        env = lib.optionalAttrs (cfg.mcp.captureDirectory != "") {
          WIRESHARK_MCP_ROOT = cfg.mcp.captureDirectory;
        };
      };
    };
  });
}
