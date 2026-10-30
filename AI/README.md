# Модуль `AI`

* **Экспорт**: `nixos`
* **Назначение**: Локальный запуск LLM через Ollama и агентный веб-интерфейс DeepSeek Harness.

## Структура

* `default.nix` — точка входа модуля, экспортирует конфигурацию NixOS (`nixos = import ./nixos.nix;`).
* `nixos.nix` — подключает системные настройки из каталога `configuration/`.
* `configuration/ollama.nix` — запускает Ollama с CUDA на стандартном `127.0.0.1:11434`, хранит модели в `/var/lib/ollama/models` и задаёт контекст 16000 токенов.
* `configuration/dsh.nix` — запускает DeepSeek Harness Web с Ollama-провайдером и моделью `qwen3.5:9b` по умолчанию. Каталог моделей строится из Ollama API при старте сервиса; после `ollama pull` достаточно перезапустить `dsh.service`.

Ollama слушает только loopback. DSH по умолчанию использует свой штатный bind; адрес, порт, public URL, trusted hosts и открытие firewall настраиваются через `services.dsh-web`. Адрес Ollama берётся из `services.ollama`, без отдельного хардкода. DSH требует официальный Node.js 22.19.0 в `~/.local/opt/node-v22.19.0-linux-x64` и установленный в `~/.local` пакет `@deepseek-ai/dsh`.

```nix
services.dsh-web = {
  host = "192.168.1.10";
  port = 5001;
  publicUrl = "https://dsh.example.org";
  trustedHosts = ["192.168.1.10:5001" "dsh.example.org"];
  openFirewall = true;
};
```
