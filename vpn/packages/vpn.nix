{pkgs, ...}: let
  mkTunCommand = name: enabled:
    pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = [
        pkgs.coreutils
        pkgs.curl
      ];
      text = ''
        socket_path="''${CLASH_VERGE_SOCKET:-/run/user/$(id -u)/clash-verge-rev/verge-mihomo.sock}"

        if [[ ! -S "$socket_path" ]]; then
          echo "Clash Verge Rev API socket not found: $socket_path" >&2
          exit 1
        fi

        curl \
          --fail \
          --silent \
          --show-error \
          --unix-socket "$socket_path" \
          --request PATCH \
          --header 'Content-Type: application/json' \
          --data '{"tun":{"enable":${if enabled then "true" else "false"}}}' \
          http://localhost/configs \
          >/dev/null

        echo "Clash Verge Rev TUN ${if enabled then "enabled" else "disabled"}"
      '';
    };
in {
  environment.systemPackages = with pkgs; [
    amnezia-vpn
    # hiddify-app
    # v2raya
    clash-verge-rev
    (mkTunCommand "vpnon" true)
    (mkTunCommand "vpnoff" false)
    # flclash
  ];
}
