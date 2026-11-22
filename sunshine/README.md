# Модуль `sunshine`

* **Экспорт**: `nixos`, `darwin`, `home`
* **Назначение**: Сервер стриминга рабочего стола и игр Sunshine с низкой задержкой.

## Структура

* `default.nix` — экспортирует слои `nixos`, `darwin` и `home`.
* `nixos.nix` — подключает `configuration/`.
* `home.nix` — подключает `home_packages/`.
* `configuration/sunshine.nix`:
  * Служба Sunshine с правами захвата KMS.
  * Открытие необходимых UDP/TCP портов в фаерволе.
  * Скрипты `sunshine-client-mode` и `sunshine-default-mode` для динамического изменения разрешения и частоты кадров под разрешение экрана клиента через IPC Hyprland.
  * Скрипт `sunshine-headless` для создания виртуального монитора без физического подключения дисплея.
* `home_packages/hypr/` — конфигурация автозапуска в Hyprland.

На Apple Silicon модуль `darwin` устанавливает Sunshine для ручного запуска. Для захвата рабочего стола выдайте разрешение на запись экрана в настройках macOS. Настройки виртуального монитора с Hyprland применяются на NixOS.
