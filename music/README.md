# Модуль `music`

* **Экспорт**: `home`
* **Назначение**: Прослушивание музыки и аудиотреков.

## Структура

* `default.nix` — экспортирует конфигурацию Home Manager.
* `home.nix` — подключает модули из каталога `home_packages/`.
* `home_packages/muffon/default.nix` — установка десктопного музыкального плеера `muffon`.

На macOS переключатель `components.music.enabledPackages.muffon` устанавливает официальный Muffon 2.5.0 для Apple Silicon или Intel. По умолчанию он включён только на Linux.
