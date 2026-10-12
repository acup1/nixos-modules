# Модуль `circuit-artist`

* **Экспорт**: `nixos`
* **Назначение**: Логическая игра-симулятор цифровых схем Circuit Artist.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `package.nix` — локальная деривация Nix для сборки Circuit Artist из исходников.
* `packages/circuit-artist.nix` — установка пакета в систему через `callPackage`.
