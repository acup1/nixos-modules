# Модуль `file-viewers`

* **Экспорт**: `nixos`, `darwin`
* **Назначение**: Просмотр файлов, изображений и воспроизведение мультимедиа.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/file_viewers.nix`:
  * Графический файловый менеджер: `nautilus`.
  * Быстрый просмотр изображений: `qimgv`.
  * Медиаплееры: `vlc`, `mpv`.

На macOS доступны mpv из nixpkgs и VLC через Homebrew Cask. Nautilus и qimgv остаются в наборе NixOS.
