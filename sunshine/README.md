# Модуль `sunshine`

* **Экспорт**: `nixos` + `home`
* **Назначение**: Сервер стриминга рабочего стола и игр Sunshine с низкой задержкой.

## Структура

* `default.nix` — экспортирует обе части: `nixos = import ./nixos.nix;` и `home = import ./home.nix;`.
* `nixos.nix` — подключает `configuration/`.
* `home.nix` — подключает `home_packages/`.
* `configuration/sunshine.nix`:
  * Служба Sunshine с правами захвата KMS.
  * Открытие необходимых UDP/TCP портов в фаерволе.
  * Скрипты `sunshine-client-mode` и `sunshine-default-mode` для динамического изменения разрешения и частоты кадров под разрешение экрана клиента через IPC Hyprland.
  * Скрипт `sunshine-headless` для создания виртуального монитора без физического подключения дисплея.
* `home_packages/hypr/` — конфигурация автозапуска в Hyprland.
