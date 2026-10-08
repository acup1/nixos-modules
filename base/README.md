# Модуль `base`

* **Экспорт**: `nixos`
* **Назначение**: Базовая системная инфраструктура и основные CLI-пакеты.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает директории `configuration/` и `packages/`.
* `packages/base.nix` — базовые утилиты: `git`, `curl`, `wget`, `htop`, `tmux`, `pciutils`, `usbutils`, `tree`, `killall`.
* `configuration/`:
  * `nix.nix` — настройки демона Nix: experimental-features (`flakes`, `nix-command`), автоматическая сборка мусора, оптимизация `/nix/store` через hard links.
  * `caches.nix` — доверенные бинарные кэши (substituters) и открытые ключи.
  * `nh.nix` — системная обертка `nh` с флагом `--impure`.
  * `networking.nix` — служба NetworkManager, оптимизация DNS, системный firewall.
  * `shell.nix` — общесистемные алиасы и Zsh как системная оболочка.
  * `sshd.nix` — настройки SSH-демона.
  * `documentation.nix` — отключение генерации документации для ускорения сборки.
