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

## Цветовая тема

`components.nvf.theme` выбирает пару из темы и варианта. По умолчанию используется `onedark/darker` с прозрачным фоном.

```nix
components.nvf.theme = "catppuccin/mocha";
```

Другие варианты включают `onedark/warm`, `catppuccin/latte` и `tokyonight/moon`. Настройки `programs.nvf.settings.vim.theme.name` и `programs.nvf.settings.vim.theme.style` позволяют выбрать другие темы и варианты, доступные в подключённой версии nvf.
