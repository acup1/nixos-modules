# Модуль `hardware`

* **Экспорт**: `nixos`, `darwin`
* **Назначение**: Диагностика, инспекция и мониторинг аппаратного обеспечения.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS и nix-darwin.
* `nixos.nix` — подключает `packages/`.
* `packages/hardware.nix`:
  * Инструмент детального анализа оборудования `hal-hardware-analyzer`.

В nix-darwin HAL устанавливается при включении `components.hardware.enabledPackages.hal-hardware-analyzer`.
