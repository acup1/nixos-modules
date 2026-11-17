{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  gdctl = "${pkgs.mutter}/bin/gdctl";
  nvidia = lib.elem "nvidia" config.services.xserver.videoDrivers;
  sunshineNvencBase = pkgs.sunshine.override { cudaSupport = false; };
  sunshineNvenc = pkgs.symlinkJoin {
    name = "${sunshineNvencBase.name}-nvenc";
    paths = [ sunshineNvencBase ];
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    # Capability-wrapper NixOS очищает LD_LIBRARY_PATH. Задаём путь
    # уже после него, перед запуском Sunshine и встроенного FFmpeg.
    # Цель capability-wrapper должна оставаться ELF, а не shell-скриптом.
    postBuild = ''
      wrapProgram "$out/bin/sunshine" \
        --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
    '';
    passthru.unwrapped = sunshineNvencBase;
    inherit (sunshineNvencBase) meta;
  };

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

  # Потоковые UDP-сокеты открываются только при подключении Moonlight.
  # До этого ядро не должно отдавать их исходящим соединениям.
  boot.kernel.sysctl."net.ipv4.ip_local_reserved_ports" =
    lib.mkDefault "47984,47989-47990,47998-48000,48002,48010";

  # TAG-= очищает только CURRENT_TAGS, а Mutter проверяет все TAGS.
  # Подменяем 61-mutter.rules после пакета Mutter, не назначая VKMS
  # mutter-device-ignore и сохраняя остальные аппаратные правила.
  services.udev.packages = lib.mkAfter [ sunshineMutterRules ];

  # GNOME иначе импортирует буфер NVIDIA прямо в VKMS. Mesa не может
  # прочитать такой буфер через VKMS: кадр остаётся чёрным (GL 0x505).
  # Mutter копирует готовый кадр в собственный dumb-буфер VKMS.
  environment.sessionVariables.MUTTER_DEBUG_MULTI_GPU_FORCE_COPY_MODE =
    lib.mkIf nvidia "primary-gpu-cpu";

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

    # Без CUDA-пути Sunshine копирует KMS-кадр через Mesa в RAM,
    # затем передаёт его аппаратному NVENC. Прямой импорт VKMS в NVIDIA
    # через Vulkan/GL не обеспечивает чтение реальных кадров.
    package = lib.mkIf nvidia (lib.mkDefault sunshineNvenc);

    settings = {
      capture = "kms";
      # Автовыбор пропускает VKMS для NVENC и выбирает неработающий Vulkan.
      encoder = lib.mkIf nvidia (lib.mkDefault "nvenc");
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
