# Модуль `games`

* **Экспорт**: `nixos`
* **Назначение**: Игры, запуск Windows-приложений и игровой клиент Steam.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `configuration/` и `packages/`.
* `configuration/steam.nix`:
  * Включение Steam (`programs.steam.enable = true`).
  * Автоматическое открытие портов в firewall для Steam Remote Play, локальной передачи файлов игр по сети (Local Network Game Transfers) и Source Dedicated Server.
* `packages/games.nix`:
  * Сборка Wine с нативной поддержкой Wayland (`wineWow64Packages.waylandFull`).
  * Менеджер префиксов Bottles.
  * Головоломка GNOME Sudoku.
