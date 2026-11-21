# nixos-installer

Добавьте `(import (modulesRoot + "/nixos-installer"))` в список `modules` в `config.nix`. После активации команда `nixos-installer configure` открывает редактор модулей. Для установки системы запустите `sudo nixos-installer install` из Linux live-среды с инструментами NixOS.

Модуль скачивает готовый бинарник для выбранной ОС и архитектуры. Версия и SHA-256 для каждого файла закреплены в `release.json`. [Релизы установщика](https://github.com/acup1/nixos-installer/releases)
