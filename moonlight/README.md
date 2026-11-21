# Модуль `moonlight`

* Доступны части `nixos` и `darwin`.
* **Назначение**: Клиент удаленного игрового стриминга.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS и nix-darwin.
* `nixos.nix` — подключает `packages/`.
* `darwin.nix` — подключает Homebrew cask `moonlight`.
* `packages/moonlight.nix`:
  * Пакет `moonlight-qt` для подключения к игровым серверам Sunshine или NVIDIA GameStream с низкой задержкой.
