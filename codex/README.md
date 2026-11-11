# Модуль `codex`

* **Экспорт**: `nixos`, `darwin`.
* **Назначение**: установка OpenAI Codex CLI из `pkgs.codex` в системный `PATH`
  на NixOS и macOS (nix-darwin).

## Подключение

Добавьте модуль в список компонентов вашей конфигурации:

```nix
(import (modulesRoot + "/codex"))
```

На macOS список находится в `~/.config/config.nix`; на NixOS — в локальном
селекторе модулей (например, `~/.config/nix/modules.nix`). Примените конфигурацию
обычной командой пересборки системы. Версия Codex определяется закреплённым
в хостовом `flake.lock` nixpkgs; npm и Homebrew для установки не требуются.

## Проверка и первый запуск

```bash
command -v codex
codex --version
codex --help
codex
```

При первом запуске войдите в аккаунт через предложенный способ авторизации.
Учётные данные и пользовательские настройки не задаются модулем.
Если в `PATH` уже есть другая установка Codex (например, `~/.local/bin/codex`),
проверьте системную версию напрямую:

```bash
/run/current-system/sw/bin/codex --version
```

Официальная документация: [Codex CLI](https://learn.chatgpt.com/docs/codex/cli).

## Структура

* `default.nix` — экспортирует части для NixOS и nix-darwin.
* `nixos.nix`, `darwin.nix` — подключают `packages/`.
* `packages/codex.nix` — добавляет `pkgs.codex` в `environment.systemPackages`.
