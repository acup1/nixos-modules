# Модуль `AI`

## NixOS

Экспорт `nixos` запускает Ollama с CUDA и Hermes Agent с чатом в официальном веб-интерфейсе. Codex CLI доступен в системном `PATH`.

- Ollama по умолчанию слушает `127.0.0.1:11434`, хранит модели в `/var/lib/ollama/models` и использует контекст 64 000 токенов.
- Веб-интерфейс Hermes по умолчанию доступен на `http://127.0.0.1:5001`. Его запускает `hermes-backend.service`. Сессии системной службы хранятся в `/var/lib/hermes/.hermes`. Команда `hermes` доступна в системном `PATH` и по умолчанию использует профиль текущего пользователя.
- Hermes получает адрес и порт из `services.ollama`. Модель `qwen3.5:9b` должна быть загружена в Ollama. Другую установленную модель можно выбрать через `services.hermes-agent.settings.model.default`.
- В чате команда `/model` открывает выбор моделей провайдера **Ollama**. Список берётся из Ollama. Выбор в чате действует в текущей сессии, а модель по умолчанию задаётся в Nix.

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

Каналы мессенджеров задаются в `services.hermes-agent.settings.platforms`, а их учётные данные хранятся в файлах из `services.hermes-agent.environmentFiles`. Панель показывает состояние каналов, а изменения в управляемой NixOS-конфигурации вступают в силу после `nh os switch`. Шлюз работает как системная служба `hermes-agent.service`. Для ручного перезапуска используйте `sudo systemctl restart hermes-agent.service`. [Настройка Hermes на NixOS](https://hermes-agent.nousresearch.com/docs/getting-started/nix-setup)

## macOS

Модуль экспортирует `home` для macOS. После входа пользователя Ollama запускается
через `launchd`, по умолчанию слушает `127.0.0.1:11434` и хранит модели в
`~/.ollama/models`. Используется пакет `pkgs.ollama` для macOS и контекст до
64 000 токенов. Codex CLI устанавливается в пользовательский профиль.

Официальный модуль Home Manager для Hermes Agent запускает панель на
`http://127.0.0.1:5001` и хранит данные в `~/.hermes`. Закреплённый выпуск Hermes
публикует пакет macOS для Apple Silicon. На Intel Mac доступны Ollama и Codex.

```nix
(import ./AI).withConfig {
  home = {
    components.AI.enabledPackages.codex = false;
    services.ollama.port = 11434;
    # Apple Silicon:
    services.hermes-agent.backend.port = 5001;
  };
}
```

Чтобы отключить приложение вместе с его агентом, установите соответствующий
`home.components.AI.enabledPackages` в `false`. Для панели за обратным прокси
передавайте учётные данные через `home.services.hermes-agent.environmentFiles`.
