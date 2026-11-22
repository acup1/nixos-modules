# Модуль `qbittorrent`

* **Экспорт**: `nixos`, `darwin`
* **Назначение**: Клиент пиринговых сетей BitTorrent.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/qbittorrent.nix`:
  * Пакет `qbittorrent`.

На обеих ОС устанавливается qBittorrent из nixpkgs.
