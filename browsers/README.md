# Модуль `browsers`

* **Экспорт**: `nixos`, `darwin`
* **Назначение**: Веб-браузеры для повседневного использования и приватности.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/browsers.nix`:
  * `google-chrome`
  * `tor-browser`
* `packages/zen.nix`:
  * Сборка Zen Browser из flake `github:youwen5/zen-browser-flake` с runtime-обёрткой библиотек `ffmpeg_8` для поддержки видеокодеков H.264/AAC.

Для Google Chrome на NixOS разрешите несвободный пакет `google-chrome` в настройках nixpkgs.

На Mac с Apple Silicon Zen используется по умолчанию. Модуль использует `inputs.zen-browser` из конфигурации хоста, если он задан, либо закреплённую версию Zen. На macOS Google Chrome и Tor Browser можно включить через `components.browsers.enabledPackages.google-chrome` и `components.browsers.enabledPackages.tor-browser`. Для них модуль использует casks Homebrew.
