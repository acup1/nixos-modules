# Модуль `android`

* **Экспорт**: `nixos`
* **Назначение**: Интеграция подсистемы Android и работа с мобильными устройствами.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — рекурсивно подключает файлы из каталога `configuration/`.
* `configuration/android.nix`:
  * `virtualisation.waydroid.enable = true` — контейнеризация Waydroid (LXC) для нативного запуска Android-приложений с аппаратным ускорением Wayland.
  * `programs.droidcam.enable = true` — интеграция DroidCam для использования смартфона в качестве беспроводной или USB веб-камеры.
