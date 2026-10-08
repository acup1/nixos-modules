# Модуль `fonts`

* **Экспорт**: `nixos`
* **Назначение**: Общесистемные шрифты и шрифты для терминалов.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/fonts.nix` — декларация шрифтов через `fonts.packages`:
  * Шрифты Microsoft: `corefonts`, `vista-fonts`.
  * Шрифты CJK: `noto-fonts-cjk-sans`, `noto-fonts-cjk-serif`.
  * Японские шрифты: `migmix`.
  * Nerd Fonts: `jetbrains-mono`, `code-new-roman`, `symbols-only`.
