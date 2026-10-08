{
  lib,
  fetchFromGitHub,
  python3Packages,
  gobject-introspection,
  wrapGAppsHook3,
  gtk3,
  libappindicator-gtk3,
  libnotify,
  dnsmasq,
  ffmpeg,
  glib,
  iproute2,
  iw,
  networkmanager,
  pipewire,
  pulseaudio,
  sudo,
  tk,
  wf-recorder,
  wpa_supplicant,
  xdg-desktop-portal,
  xrandr,
  gst_all_1,
}:
let
  buildPythonApplication = python3Packages.buildPythonApplication;
  version = "0.2.7";

  gstreamerPackages = with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    pipewire
  ];

  runtimeTools = [
    dnsmasq
    ffmpeg
    glib
    gst_all_1.gstreamer
    iproute2
    iw
    libnotify
    networkmanager
    pulseaudio
    sudo
    tk
    wf-recorder
    wpa_supplicant
    xdg-desktop-portal
    xrandr
  ];
in
  buildPythonApplication {
    pname = "fluxcast";
    inherit version;
    pyproject = true;

    src = fetchFromGitHub {
      owner = "IlyaP358";
      repo = "fluxcast";
      rev = "v${version}";
      hash = "sha256-QNx5CVSHA/rUhqQ/l916GaqVnkEcSUfvy6i2SDIbfbo=";
    };

    build-system = with python3Packages; [hatchling];

    dependencies = with python3Packages; [
      dbus-next
      pillow
      pychromecast
      pygobject3
      pystray
      upnpclient
    ];

    nativeBuildInputs = [
      gobject-introspection
      wrapGAppsHook3
    ];

    buildInputs = [
      gtk3
      libappindicator-gtk3
      libnotify
    ] ++ gstreamerPackages;

    # The v0.2.7 tag still declares the old PyPI version in pyproject.toml.
    # Keep wheel metadata and FluxCast's --version output aligned with the tag.
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'version = "0.1.5"' 'version = "${version}"'
      substituteInPlace src/version.py \
        --replace-fail '__installed_version__ = "dev"' '__installed_version__ = "${version}"'

      # NixOS administrators use wheel; a sudo group may not exist.
      sed -i '/<policy group="sudo">/,/<\/policy>/d' \
        meta/zz-dev.fluxcast.wpa-supplicant.conf
    '';

    # Keep Nix store paths for the external tools and GStreamer plugins visible
    # when FluxCast starts from its desktop entry or a terminal.
    dontWrapGApps = true;
    preFixup = ''
      makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    '';
    makeWrapperArgs = [
      "--prefix PATH : ${lib.makeBinPath runtimeTools}"
      "--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${lib.makeSearchPath "lib/gstreamer-1.0" (map lib.getLib gstreamerPackages)}"
      "--set GST_PLUGIN_SCANNER ${lib.getLib gst_all_1.gstreamer}/libexec/gstreamer-1.0/gst-plugin-scanner"
    ];

    postInstall = ''
      rm -f "$out/bin/fluxcast-install-system"
      install -Dm644 meta/fluxcast.desktop \
        "$out/share/applications/fluxcast.desktop"
      install -Dm644 src/assets/flcast_logo_512x512.png \
        "$out/share/icons/hicolor/512x512/apps/fluxcast.png"
      install -Dm644 meta/zz-dev.fluxcast.wpa-supplicant.conf \
        "$out/share/dbus-1/system.d/zz-dev.fluxcast.wpa-supplicant.conf"
    '';

    meta = {
      description = "Stream a Linux desktop to a Smart TV via Miracast, DLNA, or Chromecast";
      homepage = "https://github.com/IlyaP358/fluxcast";
      license = lib.licenses.gpl3Plus;
      mainProgram = "fluxcast";
      platforms = lib.platforms.linux;
    };
  }
