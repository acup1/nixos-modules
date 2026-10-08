# Модуль `bootloader`

* **Экспорт**: `nixos`
* **Назначение**: Конфигурация системного EFI-загрузчика GRUB и темы оформления.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `configuration/`.
* `configuration/bootloader.nix`:
  * Загрузчик GRUB UEFI (`device = "nodev"`), таймаут 2 секунды, разрешение 1920x1080.
  * Подключение темы Intervals.
  * Эмуляция `aarch64-linux` через binfmt.
* `grub_themes/` — исходники и деривация темы Intervals.
