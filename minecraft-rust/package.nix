{lib, runCommand, fetchurl, unzip}: let
  releases = "https://github.com/horizon-rust/horizon/releases/download";
  gameVersion = "nightly-2026-11-21";
  launcherVersion = "0.2.99";
  client = fetchurl {
    url = "${releases}/${gameVersion}/horizon-macos-arm64.zip";
    hash = "sha256-d3m6/8NRuVyubYV1l10cXbdc2lunMJpAZQtJxdQoGWg=";
  };
  launcher = fetchurl {
    url = "${releases}/launcher@${launcherVersion}/horizon-launcher-macos-arm64.zip";
    hash = "sha256-gqmDe3J4MrBSZ2EmBMrTvRLw/3pFcH7ugszGnLZgumc=";
  };
in
  runCommand "minecraft-rust-${gameVersion}" {
    nativeBuildInputs = [unzip];
    meta = {
      description = "Horizon, a Rust implementation of Minecraft Java Edition, with its launcher";
      homepage = "https://playhorizon.dev";
      platforms = ["aarch64-darwin"];
      mainProgram = "minecraft-rust";
      license = lib.licenses.lgpl3Plus;
    };
  } ''
    mkdir -p "$out/Applications" "$out/bin" "$out/share/minecraft-rust"
    unzip -q ${launcher} -d "$out/Applications"
    unzip -q ${client}
    mv horizon-macos-arm64 "$out/share/minecraft-rust/game"
    ln -s "$out/Applications/Horizon.app/Contents/MacOS/horizon-launcher" "$out/bin/minecraft-rust"
    ln -s "$out/share/minecraft-rust/game/horizon-client" "$out/bin/horizon-client"
  ''
