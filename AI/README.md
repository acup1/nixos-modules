# Модуль `AI`

* **Экспорт**: `nixos`
* **Назначение**: Локальный запуск LLM через Ollama и агентный веб-интерфейс DeepSeek Harness.

## Структура

* `default.nix` — точка входа модуля, экспортирует конфигурацию NixOS (`nixos = import ./nixos.nix;`).
* `nixos.nix` — подключает системные настройки из каталога `configuration/`.
* `configuration/ollama.nix` — запускает Ollama с CUDA на стандартном `127.0.0.1:11434`, хранит модели в `/var/lib/ollama/models` и задаёт контекст 16000 токенов.
* `configuration/dsh.nix` — запускает DeepSeek Harness Web на `127.0.0.1:5001` через интеграцию `ollama launch dsh` с моделью `qwen3.5:9b`.

Оба сервиса слушают только loopback. Для доступа извне используются отдельные приватные FRP-модули хоста. DSH требует официальный Node.js 22.19.0 в `~/.local/opt/node-v22.19.0-linux-x64` и установленный в `~/.local` пакет `@deepseek-ai/dsh`.
