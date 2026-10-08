# Модуль `nix-serve`

* **Экспорт**: `nixos`
* **Назначение**: Локальный бинарный кэш-сервер Nix для локальной сети.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `configuration/`.
* `configuration/nix-serve.nix`:
  * Включение `services.nix-serve.enable = true;`.
  * Привязка к адресу `0.0.0.0`, порт 5000.
  * Автоматическое открытие порта в firewall (`openFirewall = true;`).
