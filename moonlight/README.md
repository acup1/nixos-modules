# Модуль `moonlight`

* **Экспорт**: `nixos`
* **Назначение**: Клиент удаленного игрового стриминга.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/moonlight.nix`:
  * Пакет `moonlight-qt` для подключения к игровым серверам Sunshine или NVIDIA GameStream с низкой задержкой.
