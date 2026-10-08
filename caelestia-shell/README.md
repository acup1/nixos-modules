# Модуль `caelestia-shell`

* **Экспорт**: `nixos`
* **Назначение**: Кастомная графическая оболочка Caelestia Shell.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/caelestia-shell.nix`:
  * Импортирует и устанавливает пакет оболочки напрямую из внешнего репозитория `github:caelestia-dots/shell`.
