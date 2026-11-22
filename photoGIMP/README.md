# Модуль `photoGIMP`

* **Экспорт**: `home`, `darwin`
* **Назначение**: Растровый графический редактор GIMP 3 с эргономичным интерфейсом Adobe Photoshop.

## Структура

* `default.nix` — экспортирует конфигурацию Home Manager.
* `home.nix` — подключает модули из каталога `home_packages/`.
* `home_packages/gimp/default.nix`:
  * Пакет `gimp3`.
  * На Linux хук активации Home Manager `copyPhotoGIMPConfig` копирует раскладку панелей, горячие клавиши и тему из закреплённой ревизии в `~/.config/GIMP`.

На macOS переключатель `components.photoGIMP.enabledPackages.gimp3` устанавливает GIMP через Homebrew и применяет официальный архив PhotoGIMP 3.1 в `~/Library/Application Support/GIMP` для GIMP 3.0 и 3.2. В ручном селекторе укажите переключатель в слоях `darwin` и `home`.
