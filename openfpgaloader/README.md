# Модуль `openfpgaloader`

* **Экспорт**: `nixos`
* **Назначение**: Прошивка и отладка программируемых логических интегральных схем (FPGA).

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `configuration/` и `packages/`.
* `packages/openfpgaloader.nix`:
  * Утилита прошивки `openfpgaloader`.
* `configuration/udev_rules.nix`:
  * Системные udev-правила для предоставления доступа непривилегированным пользователям к USB-JTAG программаторам (FTDI, CMSIS-DAP и др.).
