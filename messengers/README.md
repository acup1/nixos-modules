# Модуль `messengers`

* **Экспорт**: `nixos`, `darwin`
* **Назначение**: Клиенты мгновенных сообщений и голосовой связи.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/messengers.nix`:
  * `telegram-desktop`
  * `discord`

На macOS Telegram Desktop и Discord устанавливаются из nixpkgs, а Rocket.Chat — через Homebrew Cask.
