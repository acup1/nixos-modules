# Модуль `terminal`

Этот компонент сохраняет прежние импорты `nixos` и `home` и настройки
`components.terminal`. В новых селекторах можно выбирать
`terminal-emulators`, `shell` и `cli-tools` по отдельности.

| Что настраивает прежний переключатель | Новый компонент |
| --- | --- |
| Alacritty, Ghostty и шрифты Ghostty | `terminal-emulators` |
| Zsh и Starship | `shell` |
| btop, Cava, Yazi и системные CLI-утилиты | `cli-tools` |

Переключатели используют прежние имена пакетов в
`components.<имя компонента>.enabledPackages`. Новая настройка
`components.terminal-emulators.showWindowDecorations` управляет рамками окон
в слое Home Manager.

Старый импорт также позволяет по отдельности включить Alacritty и совместимые системные CLI-пакеты на macOS.
