# nixos-installer

Добавьте `(import (modulesRoot + "/nixos-installer"))` в список `modules` в `config.nix`. Укажите каталог базового flake в поле `flakeDir` этого же файла. После активации команда `nixos-installer configure` открывает редактор с конфигурацией хоста. На странице просмотра кнопка **Rebuild** сохраняет настройки и сразу запускает `nh` для выбранной системы. Для установки NixOS из Linux live-среды запустите `sudo nixos-installer install`.

Модуль скачивает готовый бинарник для выбранной ОС и архитектуры. Версия и SHA-256 для каждого файла закреплены в `release.json`. [Релизы установщика](https://github.com/acup1/nixos-installer/releases)
