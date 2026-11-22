# Документация модулей системы (`modules/`)

## Настройка в `config.nix`

Добавляйте компоненты в `modules`. Обычный импорт выбирает настройки по умолчанию. Метод `withConfig` принимает `enable` и модули настроек для `nixos`, `darwin` и `home`. Хост выбирает нужную системную часть и отдельно применяет Home Manager.

```nix
modules = [
  (import (modulesRoot + "/base"))
  ((import (modulesRoot + "/devops")).withConfig {
    nixos.components.devops.enabledPackages.terraform = false;
    darwin.components.devops.enabledPackages.colima = false;
  })
];
```

Укажите `components.<компонент>.enabledPackages.<пакет> = false;` в нужном слое, чтобы исключить пакет и его сервисы из этого компонента. Например, отключение Colima в `devops` убирает пакет и его launchd-агент. Доступные имена перечислены в `module.json` компонента. Установщик записывает выбор для всех применимых слоёв в `config.nix`. Если тот же пакет нужен другому компоненту, тот может его установить. Для своих дополнительных пакетов можно по-прежнему использовать `components.<компонент>.packages`.

Для Home Manager базовый flake передаёт целевую платформу через `extraSpecialArgs.system`, например `"aarch64-darwin"`. По ней компоненты рабочего стола выбирают подходящие импорты. Списки пакетов учитывают поддерживаемые платформы nixpkgs.

Каталог установщика читает `module.json` из каталогов компонентов. Компоненты `nvf` и `WM-DE/{common,drift,hypr}` хранят версии своих внешних зависимостей в отдельных flakes. Хост может переопределить их через `inputs`.

## Терминал и локальные каталоги

В `config.nix` можно независимо выбрать эмуляторы, оболочку и CLI-утилиты. Например, для тайлингового рабочего стола:

```nix
modules = [
  ((import (modulesRoot + "/terminal-emulators")).withConfig {
    home.components.terminal-emulators.showWindowDecorations = false;
  })
  (import (modulesRoot + "/shell"))
  (import (modulesRoot + "/cli-tools"))
];
```

`showWindowDecorations` управляет оформлением окон Ghostty и Alacritty. Значение `true` включает декорации. Пользовательские настройки применяются через Home Manager.

Для своего каталога укажите `moduleSources = [ modulesRoot /absolute/path/to/private-modules ];` в селекторе хоста. Каждый компонент каталога содержит `default.nix` и `module.json`. Установщик показывает все компоненты и отмечает недоступные на выбранной платформе пакеты и настройки. Для локальных каталогов Git необязателен.

Для новых конфигураций наборы macOS выбираются по назначению, например `browsers`, `dev`, `fonts` или `cli-tools`. Прежний путь `macos-packages/default.nix` поддерживает существующие ручные импорты.

## Сводная таблица модулей

| Модуль | Тип | Краткое описание | Документация |
| :--- | :--- | :--- | :--- |
| **AI** | NixOS + Home (macOS) | Ollama, веб-чат Hermes Agent и Codex CLI | [AI/README.md](AI/README.md) |
| **android** | NixOS | Подсистема Android (Waydroid) и вебкамера через телефон (DroidCam) | [android/README.md](android/README.md) |
| **base** | NixOS + Darwin | Базовая система: сеть, Nix, кэши, NH, SSH, локаль, Zsh | [base/README.md](base/README.md) |
| **bootloader** | NixOS | GRUB UEFI загрузчик с кастомной темой Intervals и поддержкой aarch64 | [bootloader/README.md](bootloader/README.md) |
| **browsers** | NixOS + Darwin | Веб-браузеры: Google Chrome, Tor Browser, Zen Browser | [browsers/README.md](browsers/README.md) |
| **caelestia-shell** | NixOS | Оболочка Caelestia Shell из внешнего Flake | [caelestia-shell/README.md](caelestia-shell/README.md) |
| **circuit-artist** | NixOS | Логическая игра-симулятор цифровых схем Circuit Artist | [circuit-artist/README.md](circuit-artist/README.md) |
| **codex** | NixOS + Darwin | OpenAI Codex CLI | [codex/README.md](codex/README.md) |
| **dev** | NixOS + Darwin | Языки и компиляторы: C/C++, Rust, Go, Python, Node.js, Arduino | [dev/README.md](dev/README.md) |
| **devops** | NixOS + Darwin | Контейнеризация и виртуализация: Docker, Kubernetes, QEMU, libvirtd, Terraform | [devops/README.md](devops/README.md) |
| **doc-redactors** | NixOS + Darwin | Офис и документы: LibreOffice, WPS Office, Typst, LaTeX, PDF-утилиты, Obsidian | [doc-redactors/README.md](doc-redactors/README.md) |
| **file-viewers** | NixOS + Darwin | Файловый менеджер Nautilus, просмотрщик картинок qimgv, плееры VLC и mpv | [file-viewers/README.md](file-viewers/README.md) |
| **fluxcast** | NixOS | Утилита трансляции Fluxcast (локальная сборка из исходников) | [fluxcast/README.md](fluxcast/README.md) |
| **fonts** | NixOS + Darwin | Системные шрифты (MS Core Fonts, Noto CJK, MigMix) и Nerd Fonts | [fonts/README.md](fonts/README.md) |
| **fprint** | NixOS | Аутентификация по отпечатку пальца через PAM и fprintd | [fprint/README.md](fprint/README.md) |
| **games** | NixOS + Darwin | Игры: Wine Wayland, Bottles, Sudoku, Steam с пробросом портов | [games/README.md](games/README.md) |
| **gnome-theming** | Home (Linux) | Расширения GNOME Shell для панели, дока и рабочего стола | [gnome-theming/README.md](gnome-theming/README.md) |
| **graphics** | NixOS + Darwin | САПР и графика: FreeCAD, Darktable, библиотеки OpenGL/Nvidia/Mesa | [graphics/README.md](graphics/README.md) |
| **hardware** | NixOS | Диагностика оборудования (HAL Hardware Analyzer) | [hardware/README.md](hardware/README.md) |
| **kicad** | Darwin + Home | САПР печатных плат KiCad | [kicad/README.md](kicad/README.md) |
| **macos-base** | Darwin | Базовые настройки macOS | [macos-base/default.nix](macos-base/default.nix) |
| **macos-home** | Home (macOS) | Совместимость с прежним набором настроек терминала macOS | [macos-home/default.nix](macos-home/default.nix) |
| **macos-keyboard** | Darwin + Home (macOS) | Клавиатурные сочетания Karabiner | [macos-keyboard/README.md](macos-keyboard/README.md) |
| **macos-tiling** | Darwin + Home (macOS) | Тайлинг yabai и сочетания skhd | [macos-tiling/README.md](macos-tiling/README.md) |
| **math** | NixOS + Darwin | Математика и радио: Qalculate GTK, GNU Octave, GNU Radio | [math/README.md](math/README.md) |
| **messengers** | NixOS + Darwin | Мессенджеры: Telegram Desktop, Discord | [messengers/README.md](messengers/README.md) |
| **minecraft-rust** | Darwin (Apple Silicon) | Minecraft Java Edition 26.3 на Rust, игровой клиент и лаунчер Horizon | [minecraft-rust/README.md](minecraft-rust/README.md) |
| **moonlight** | NixOS + Darwin | Клиент игрового стриминга Moonlight | [moonlight/README.md](moonlight/README.md) |
| **multimedia** | NixOS + Darwin | Запись и стриминг экрана: OBS Studio | [multimedia/README.md](multimedia/README.md) |
| **music** | Home (x86_64 Linux) | Музыкальный плеер Muffon | [music/README.md](music/README.md) |
| **nix-serve** | NixOS | Локальный бинарный кэш-сервер Nix на порту 5000 | [nix-serve/README.md](nix-serve/README.md) |
| **nixos-installer** | NixOS + Darwin | Готовый бинарник установщика и редактора конфигурации | [nixos-installer/README.md](nixos-installer/README.md) |
| **nvf** | Home | Модульная конфигурация Neovim на базе фреймворка nvf | [nvf/README.md](nvf/README.md) |
| **openfpgaloader** | NixOS + Darwin | Программатор FPGA с правилами udev для отладочных плат | [openfpgaloader/README.md](openfpgaloader/README.md) |
| **photoGIMP** | Home (Linux) | GIMP 3 с темой и раскладкой PhotoGIMP (Photoshop UI) | [photoGIMP/README.md](photoGIMP/README.md) |
| **printing** | NixOS + Darwin | Печать: пакеты CUPS и драйвер fxlinuxprint | [printing/README.md](printing/README.md) |
| **qbittorrent** | NixOS + Darwin | Торрент-клиент qBittorrent | [qbittorrent/README.md](qbittorrent/README.md) |
| **ru-locale** | NixOS | Русская локализация (`ru_RU.UTF-8`) и системная консоль | [ru-locale/README.md](ru-locale/README.md) |
| **sound** | NixOS | Звук: Pipewire и утилита управления воспроизведением Playerctl | [sound/README.md](sound/README.md) |
| **sunshine** | NixOS + Darwin + Home (Linux) | Сервер игрового стриминга Sunshine, скрипты виртуального монитора | [sunshine/README.md](sunshine/README.md) |
| **cli-tools** | NixOS + Darwin + Home | CLI-утилиты и настройки Yazi и btop | [cli-tools](cli-tools/default.nix) |
| **shell** | NixOS + Darwin + Home | Zsh и приглашение Starship | [shell](shell/default.nix) |
| **terminal-emulators** | NixOS + Darwin + Home | Ghostty, Alacritty и декорации окон | [terminal-emulators](terminal-emulators/default.nix) |
| **terminal** | NixOS + Home | CLI утилиты, терминал Ghostty/Alacritty, конфиги btop, cava, yazi, zsh | [terminal/README.md](terminal/README.md) |
| **udev-rules** | NixOS | Дополнительные системные правила udev | [udev-rules/README.md](udev-rules/README.md) |
| **vpn** | NixOS + Darwin | VPN и прокси: Amnezia VPN, Clash Verge с TUN-режимом | [vpn/README.md](vpn/README.md) |
| **wireshark** | NixOS + Darwin + Home | Wireshark, захват без sudo и MCP для файлов PCAP | [wireshark/README.md](wireshark/README.md) |
| **vscode** | Home | Редактор VS Code с кастомной темой acup, Vim-режимом и расширениями | [vscode/README.md](vscode/README.md) |
| **WM-DE** | NixOS + Home | Оконные менеджеры (Hyprland, Niri, DriftWM, GNOME) и общий слой `common` | [WM-DE/README.md](WM-DE/README.md) |
