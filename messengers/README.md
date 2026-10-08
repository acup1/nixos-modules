# Модуль `messengers`

* **Экспорт**: `nixos`
* **Назначение**: Клиенты мгновенных сообщений и голосовой связи.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/messengers.nix`:
  * `telegram-desktop`
  * `discord`
