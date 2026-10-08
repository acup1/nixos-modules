{
  username,
  pkgs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.allowed-users = ["${username}"];
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib # libstdc++
      stdenv.cc.cc
      zlib # libz
      libGL
      glib
      openssl
      llvmPackages.libclang.lib
    ];
  };

  system.userActivationScripts.fixRustupLld = {
    text = ''
      for lld in /home/${username}/.rustup/toolchains/*/lib/rustlib/*/bin/gcc-ld/ld.lld; do
        if [ -f "$lld" ]; then
          cat << 'EOF' > "$lld"
#!/usr/bin/env bash
set -eu -o pipefail +o posix
shopt -s nullglob
prog="$(dirname "$0")/../gcc-ld-unwrapped/ld.lld"
current_wrapper="$(dirname "$(readlink -f "$(command -v rustup 2>/dev/null || echo "")")")/../nix-support/ld-wrapper.sh"
if [ -n "$current_wrapper" ] && [ -f "$current_wrapper" ]; then
    export PROG="$prog"
    "$current_wrapper" "$@"
elif [ -f "$prog" ]; then
    exec "$prog" "$@"
fi
EOF
          chmod +x "$lld"
        fi
      done
    '';
  };
}
