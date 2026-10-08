# Модуль `ru-locale`

* **Экспорт**: `nixos`
* **Назначение**: Системная локализация и настройки консоли для русского языка.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `configuration/`.
* `configuration/locale.nix`:
  * Язык системы: `ru_RU.UTF-8` для всех параметров (LC_TIME, LC_MESSAGES, LC_NUMERIC и т.д.).
  * Консольный шрифт `cyr-sun16`.
  * Консольная раскладка клавиатуры `ruwin_alt_sh-UTF-8`.
