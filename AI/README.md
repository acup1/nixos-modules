# Модуль `AI`

Экспортирует `nixos`. Запускает Ollama с CUDA и Hermes Agent с чатом в официальном веб-интерфейсе. Подключает модуль `codex`, который добавляет Codex CLI в системный `PATH`.

- Ollama по умолчанию слушает `127.0.0.1:11434`, хранит модели в `/var/lib/ollama/models` и использует контекст 64 000 токенов.
- Веб-интерфейс Hermes по умолчанию доступен на `http://127.0.0.1:5001`. Его запускает `hermes-backend.service`. Сессии Hermes хранятся в `/var/lib/hermes/.hermes`.
- Hermes получает адрес и порт из `services.ollama`. Модель `qwen3.5:9b` должна быть загружена в Ollama. Другую установленную модель можно выбрать через `services.hermes-agent.settings.model.default`.

Для прокси с HTTPS задайте публичный URL и подключите файл с параметрами входа.

```nix
services.hermes-web = {
  host = "127.0.0.1";
  port = 5001;
  publicUrl = "https://hermes.example.org";
};
services.hermes-agent.environmentFiles = ["/etc/hermes/dashboard.env"];
```

Hermes требует аутентификацию при внешнем bind или публичном URL. Храните параметры входа вне Nix store. Для публичного доступа настройте OIDC и TLS. Для прямого доступа из доверенной сети задайте локальный адрес в `services.hermes-web.host` и при необходимости включите `services.hermes-web.openFirewall`. [Настройка аутентификации Hermes](https://hermes-agent.nousresearch.com/docs/user-guide/features/web-dashboard#authentication)
