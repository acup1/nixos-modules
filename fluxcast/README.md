# Модуль `fluxcast`

* **Экспорт**: `nixos`
* **Назначение**: Утилита трансляции и захвата экрана Fluxcast.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `configuration/` и `packages/`.
* `package.nix` — локальная деривация Nix для сборки Fluxcast из исходников.
* `packages/fluxcast.nix` — установка пакета через `callPackage`.
* `configuration/fluxcast.nix` — системные параметры и настройки службы.
