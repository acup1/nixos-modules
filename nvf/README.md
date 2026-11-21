# Модуль `nvf`

* **Экспорт**: `home`
* **Назначение**: Конфигурация текстового редактора Neovim на базе фреймворка `nvf`.

## Структура

* `default.nix` — экспортирует конфигурацию Home Manager.
* `home.nix` — подключает модули из каталога `home_packages/`.
* `home_packages/nvf/default.nix`:
  * Загружает настройки из `settings.nix`.
  * Цветовая тема Onedark (стиль darker, прозрачный фон).
  * Границы окон `ui.borders`.
  * Плагин комментирования кода `mini.comment`.

## Flake

Компонент экспортирует `homeManagerModules.default` из `nvf/flake.nix`. При обычном импорте он использует `inputs.nvf` хоста, если тот его передал, или собственный `flake.lock`.
