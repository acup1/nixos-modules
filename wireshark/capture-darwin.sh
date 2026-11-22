# Invoked by launchd as root. This group is owned exclusively by the module.
set -eu
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
helper=$1
shift
group=_nix_wireshark
if ! dscl . -read "/Groups/$group" PrimaryGroupID >/dev/null 2>&1; then
  dseditgroup -q -o create -r 'Nix Wireshark capture users' "$group"
fi
dscl . -create "/Groups/$group" GroupMembership "$@"

external=false
cleanup() {
  if "$external"; then
    dseditgroup -o edit -d "$group" -t group access_bpf
    return
  fi
  for device in /dev/bpf[0-9]*; do
    [ -c "$device" ] || continue
    if [ "$(stat -f '%Sg' "$device")" = "$group" ]; then
      chmod g-rw "$device" && chgrp wheel "$device"
    fi
  done
}
trap cleanup EXIT
trap 'exit 0' TERM INT
if launchctl print system/org.wireshark.ChmodBPF >/dev/null 2>&1; then
  # Preserve privileges already granted by the upstream Wireshark installer.
  external=true
  dseditgroup -o edit -a "$group" -t group access_bpf
else
  /bin/zsh "$helper"
fi
# Keeping the job alive lets launchd revoke group access on unload or switch.
while :; do
  sleep 86400 &
  wait "$!"
done
