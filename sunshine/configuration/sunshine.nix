{
  lib,
  pkgs,
  username,
  ...
}: let
  gdctl = "${pkgs.mutter}/bin/gdctl";

  sunshineMutterRules = pkgs.runCommand "sunshine-mutter-udev-rules" {} ''
    install -Dm644 ${pkgs.mutter}/lib/udev/rules.d/61-mutter.rules \
      "$out/lib/udev/rules.d/61-mutter.rules"
    sed -i '/vkms/ { /mutter-device-ignore/d; }' \
      "$out/lib/udev/rules.d/61-mutter.rules"
  '';

  sunshineSetMode = pkgs.writeShellScript "sunshine-set-mode" ''
    set -eu
    export LC_ALL=C

    mode=$(${pkgs.coreutils}/bin/printf '%sx%s@%.3f' "$1" "$2" "$3")
    ${gdctl} set --logical-monitor --primary --scale 1 \
      --monitor Virtual-1 --mode "$mode"
  '';

  sunshineDefaultMode = pkgs.writeShellScript "sunshine-default-mode" ''
    set -eu

    ${sunshineSetMode} 1920 1080 60
  '';

  sunshineClientMode = pkgs.writeShellScript "sunshine-client-mode" ''
    set -eu

    stream_width="''${SUNSHINE_CLIENT_WIDTH:-1920}"
    stream_height="''${SUNSHINE_CLIENT_HEIGHT:-1080}"
    stream_fps="''${SUNSHINE_CLIENT_FPS:-60}"

    if ! ${sunshineSetMode} "$stream_width" "$stream_height" "$stream_fps"; then
      echo "VKMS mode unavailable; falling back to 1920x1080@60" >&2
      ${sunshineDefaultMode}
    fi
  '';

  sunshineHeadless = pkgs.writeShellScript "sunshine-headless" ''
    set -eu

    ready=0
    for attempt in $(${pkgs.coreutils}/bin/seq 1 50); do
      if ${sunshineDefaultMode}; then
        ready=1
        break
      fi
      ${pkgs.coreutils}/bin/sleep 0.2
    done

    if [ "$ready" -ne 1 ]; then
      echo "GNOME virtual display Virtual-1 is not ready" >&2
      exit 1
    fi
  '';
in {
  # VKMS предоставляет GNOME виртуальный DRM-дисплей без HDMI-заглушки.
  boot.kernelModules = [ "vkms" ];

  # TAG-= очищает только CURRENT_TAGS, а Mutter проверяет все TAGS.
  # Подменяем 61-mutter.rules после пакета Mutter, не назначая VKMS
  # mutter-device-ignore и сохраняя остальные аппаратные правила.
  services.udev.packages = lib.mkAfter [ sunshineMutterRules ];

  # GDM сразу запускает пользовательскую сессию GNOME.
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = username;
    };
    defaultSession = lib.mkForce "gnome";
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = true;

    # Виртуальный выход VKMS доступен через KMS и требует CAP_SYS_ADMIN.
    capSysAdmin = true;

    settings = {
      capture = "kms";
      # gdctl оставляет Virtual-1 единственным активным выходом.
      output_name = "0";
      global_prep_cmd = builtins.toJSON [
        {
          do = "${sunshineClientMode}";
          undo = "${sunshineDefaultMode}";
        }
      ];
      csrf_allowed_origins =
        "https://nixos:47990,https://nixos.local:47990,https://192.168.0.2:47990,https://ru.cupscloud.ru:4799,https://ru.cupscloud.ru:47990";
    };
  };

  systemd.user.services.sunshine = {
    # Не запускать Sunshine в пользовательской сессии самого GDM.
    unitConfig.ConditionUser = username;
    # ExecStartPre повторяется вместе с Sunshine при неготовой сессии GNOME.
    serviceConfig.ExecStartPre = sunshineHeadless;
  };
}
