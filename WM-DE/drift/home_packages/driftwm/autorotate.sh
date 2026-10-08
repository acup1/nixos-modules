# shellcheck shell=bash

output="${1:-eDP-1}"
export LC_ALL=C

# Handle the initial reading (with or without tilt) as well as later changes.
orientation_pattern='(Has accelerometer \(orientation: |Accelerometer orientation changed: )(normal|left-up|bottom-up|right-up)([,)]|$)'

stdbuf -oL monitor-sensor --accel | while IFS= read -r line; do
  if [[ ! "$line" =~ $orientation_pattern ]]; then
    continue
  fi

  case "${BASH_REMATCH[2]}" in
    normal) transform=normal ;;
    left-up) transform=90 ;;
    bottom-up) transform=180 ;;
    right-up) transform=270 ;;
  esac

  if [[ "$transform" == "${last_transform:-}" ]]; then
    continue
  fi

  # Retry on subsequent readings if the display is temporarily unavailable.
  if timeout 5s wlr-randr --output "$output" --transform "$transform"; then
    last_transform="$transform"
    printf 'driftwm-autorotate: %s -> %s\n' "$output" "$transform"
  else
    printf 'driftwm-autorotate: could not rotate %s to %s\n' "$output" "$transform" >&2
  fi
done
