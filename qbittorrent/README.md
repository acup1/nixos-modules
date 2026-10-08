# Модуль `qbittorrent`

* **Экспорт**: `nixos`
* **Назначение**: Клиент пиринговых сетей BitTorrent.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/qbittorrent.nix`:
  * Пакет `qbittorrent`.
