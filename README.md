# Документация модулей системы (`modules/`)

В этом каталоге расположены модули компонентов системы и пользовательского окружения. Каждый модуль автономен и может предоставлять часть для NixOS (`nixos = import ./nixos.nix;`) и/или часть для Home Manager (`home = import ./home.nix;`).

Подключение модулей осуществляется через список в `/home/acup/flakes/modules.nix` (и `~/.config/nix/modules.nix`). Подробная документация по каждому модулю находится в файле `README.md` внутри соответствующей директории.

---

## Сводная таблица модулей

| Модуль | Тип | Краткое описание | Документация |
| :--- | :--- | :--- | :--- |
| **AI** | NixOS | Локальный ИИ (заготовки для Ollama и LM Studio) | [AI/README.md](AI/README.md) |
| **android** | NixOS | Подсистема Android (Waydroid) и вебкамера через телефон (DroidCam) | [android/README.md](android/README.md) |
| **base** | NixOS | Базовая система: сеть, Nix, кэши, NH, SSH, локаль, Zsh | [base/README.md](base/README.md) |
| **bootloader** | NixOS | GRUB UEFI загрузчик с кастомной темой Intervals и поддержкой aarch64 | [bootloader/README.md](bootloader/README.md) |
| **browsers** | NixOS | Веб-браузеры: Google Chrome, Tor Browser, Zen Browser | [browsers/README.md](browsers/README.md) |
| **caelestia-shell** | NixOS | Оболочка Caelestia Shell из внешнего Flake | [caelestia-shell/README.md](caelestia-shell/README.md) |
| **dev** | NixOS | Языки и компиляторы: C/C++, Rust, Go, Python, Node.js, Arduino | [dev/README.md](dev/README.md) |
| **devops** | NixOS | Контейнеризация и виртуализация: Docker, Kubernetes, QEMU, libvirtd, Terraform | [devops/README.md](devops/README.md) |
| **doc-redactors** | NixOS | Офис и документы: LibreOffice, WPS Office, Typst, LaTeX, PDF-утилиты, Obsidian | [doc-redactors/README.md](doc-redactors/README.md) |
| **file-viewers** | NixOS | Файловый менеджер Nautilus, просмотрщик картинок qimgv, плееры VLC и mpv | [file-viewers/README.md](file-viewers/README.md) |
| **fluxcast** | NixOS | Утилита трансляции Fluxcast (локальная сборка из исходников) | [fluxcast/README.md](fluxcast/README.md) |
| **fonts** | NixOS | Системные шрифты (MS Core Fonts, Noto CJK, MigMix) и Nerd Fonts | [fonts/README.md](fonts/README.md) |
| **fprint** | NixOS | Аутентификация по отпечатку пальца через PAM и fprintd | [fprint/README.md](fprint/README.md) |
| **games** | NixOS | Игры: Wine Wayland, Bottles, Sudoku, Steam с пробросом портов | [games/README.md](games/README.md) |
| **graphics** | NixOS | САПР и графика: FreeCAD, Darktable, библиотеки OpenGL/Nvidia/Mesa | [graphics/README.md](graphics/README.md) |
| **hardware** | NixOS | Диагностика оборудования (HAL Hardware Analyzer) | [hardware/README.md](hardware/README.md) |
| **kicad** | Home | САПР печатных плат KiCad | [kicad/README.md](kicad/README.md) |
| **math** | NixOS | Математика и радио: Qalculate GTK, GNU Octave, GNU Radio | [math/README.md](math/README.md) |
| **messengers** | NixOS | Мессенджеры: Telegram Desktop, Discord | [messengers/README.md](messengers/README.md) |
| **moonlight** | NixOS | Клиент игрового стриминга Moonlight | [moonlight/README.md](moonlight/README.md) |
| **multimedia** | NixOS | Запись и стриминг экрана: OBS Studio | [multimedia/README.md](multimedia/README.md) |
| **music** | Home | Музыкальный плеер Muffon | [music/README.md](music/README.md) |
| **nix-serve** | NixOS | Локальный бинарный кэш-сервер Nix на порту 5000 | [nix-serve/README.md](nix-serve/README.md) |
| **nvf** | Home | Модульная конфигурация Neovim на базе фреймворка nvf | [nvf/README.md](nvf/README.md) |
| **openfpgaloader** | NixOS | Программатор FPGA с правилами udev для отладочных плат | [openfpgaloader/README.md](openfpgaloader/README.md) |
| **photoGIMP** | Home | GIMP 3 с темой и раскладкой PhotoGIMP (Photoshop UI) | [photoGIMP/README.md](photoGIMP/README.md) |
| **printing** | NixOS | Печать: пакеты CUPS и драйвер fxlinuxprint | [printing/README.md](printing/README.md) |
| **qbittorrent** | NixOS | Торрент-клиент qBittorrent | [qbittorrent/README.md](qbittorrent/README.md) |
| **ru-locale** | NixOS | Русская локализация (`ru_RU.UTF-8`) и системная консоль | [ru-locale/README.md](ru-locale/README.md) |
| **sound** | NixOS | Звук: Pipewire и утилита управления воспроизведением Playerctl | [sound/README.md](sound/README.md) |
| **sunshine** | NixOS + Home | Сервер игрового стриминга Sunshine, скрипты виртуального монитора | [sunshine/README.md](sunshine/README.md) |
| **terminal** | NixOS + Home | CLI утилиты, терминал Ghostty/Alacritty, конфиги btop, cava, yazi, zsh | [terminal/README.md](terminal/README.md) |
| **udev-rules** | NixOS | Дополнительные системные правила udev | [udev-rules/README.md](udev-rules/README.md) |
| **vpn** | NixOS | VPN и прокси: Amnezia VPN, Clash Verge с TUN-режимом | [vpn/README.md](vpn/README.md) |
| **vscode** | Home | Редактор VS Code с кастомной темой acup, Vim-режимом и расширениями | [vscode/README.md](vscode/README.md) |
| **WM-DE** | NixOS + Home | Оконные менеджеры (Hyprland, Niri, DriftWM, GNOME) и общий слой `common` | [WM-DE/README.md](WM-DE/README.md) |
