# Модуль `nvf`

* **Экспорт**: `home`
* **Назначение**: Конфигурация текстового редактора Neovim на базе фреймворка `nvf`.

## Структура

* `default.nix` — экспортирует конфигурацию Home Manager.
* `home.nix` — подключает модули из каталога `home_packages/`.
* `home_packages/nvf/default.nix`:
  * Интеграция с `inputs.nvf.homeManagerModules.default`.
  * Цветовая тема Onedark (стиль darker, прозрачный фон).
  * Границы окон `ui.borders`.
  * Плагин комментирования кода `mini.comment`.
