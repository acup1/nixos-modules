# Модуль `graphics`

* **Экспорт**: `nixos`
* **Назначение**: Компьютерная графика, 3D-моделирование и графические драйверы.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/graphics.nix`:
  * Инженерный 3D-САПР `freecad-wayland`.
  * Профессиональный RAW-проявитель `darktable`.
  * Графические библиотеки и тесты: `libglvnd`, `coin3d`, `mesa-demos`.
  * Драйверы Nvidia: `linuxPackages.nvidia_x11`.
