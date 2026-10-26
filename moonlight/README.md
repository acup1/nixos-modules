# Модуль `moonlight`

* **Экспорт**: `nixos`, `darwin`
* **Назначение**: Клиент удаленного игрового стриминга.

## Структура

* `default.nix` — экспортирует конфигурации NixOS и nix-darwin.
* `nixos.nix` — подключает `packages/`.
* `darwin.nix` — устанавливает Moonlight через Homebrew Cask.
* `packages/moonlight.nix`:
  * Пакет `moonlight-qt` для подключения к игровым серверам Sunshine или NVIDIA GameStream с низкой задержкой.
