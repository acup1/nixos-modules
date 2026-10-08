# Модуль `photoGIMP`

* **Экспорт**: `home`
* **Назначение**: Растровый графический редактор GIMP 3 с эргономичным интерфейсом Adobe Photoshop.

## Структура

* `default.nix` — экспортирует конфигурацию Home Manager.
* `home.nix` — подключает модули из каталога `home_packages/`.
* `home_packages/gimp/default.nix`:
  * Пакет `gimp3`.
  * Хук активации Home Manager `copyPhotoGIMPConfig`: загружает репозиторий PhotoGIMP по фиксированному хэшу и копирует раскладку панелей, горячие клавиши и тему в `~/.config/GIMP`.
