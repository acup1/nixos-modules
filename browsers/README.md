# Модуль `browsers`

* **Экспорт**: `nixos`
* **Назначение**: Веб-браузеры для повседневного использования и приватности.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/browsers.nix`:
  * `google-chrome`
  * `tor-browser`
* `packages/zen.nix`:
  * Сборка Zen Browser из flake `github:youwen5/zen-browser-flake` с runtime-обёрткой библиотек `ffmpeg_8` для поддержки видеокодеков H.264/AAC.
