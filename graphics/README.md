# Модуль `graphics`

* **Экспорт**: `nixos`, `darwin`
* **Назначение**: Компьютерная графика, 3D-моделирование и графические драйверы.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/graphics.nix`:
  * Инженерный 3D-САПР `freecad-wayland`.
  * Профессиональный RAW-проявитель `darktable`.
  * Графические библиотеки и тесты: `libglvnd`, `coin3d`, `mesa-demos`.
  * Драйверы Nvidia: `linuxPackages.nvidia_x11`.

На macOS доступны Coin3D и Darktable из nixpkgs, а FreeCAD — через Homebrew Cask. Драйверы и утилиты OpenGL из Linux-набора остаются в NixOS.

В Darwin `libglvnd` можно включить отдельно для программ OpenGL.
