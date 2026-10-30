# Модуль `vpn`

* **Экспорт**: `nixos`
* **Назначение**: Клиенты виртуальных частных сетей и прокси-соединений.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `configuration/` и `packages/`.
* `configuration/vpn.nix`:
  * Включение `programs.clash-verge.enable = true` с режимами `serviceMode`, `tunMode` и автоматическим запуском.
  * Включение `programs.amnezia-vpn.enable = true`.
* `packages/vpn.nix`:
  * Установка пакетов `amnezia-vpn` и `clash-verge-rev`.
  * Команды `vpnon` и `vpnoff` включают и выключают TUN через локальный Unix-сокет API Clash Verge Rev.
    Путь к сокету можно переопределить переменной `CLASH_VERGE_SOCKET`.
