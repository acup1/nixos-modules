# Модуль `browsers`

* **Экспорт**: `nixos`, `darwin`, `home`
* **Назначение**: Веб-браузеры для повседневного использования и приватности.

## Структура

* `default.nix` — экспортирует слои NixOS, nix-darwin и Home Manager.
* `nixos.nix` — подключает `packages/`.
* `packages/browsers.nix`:
  * `google-chrome`
  * `tor-browser`
* `packages/zen.nix`:
  * Сборка Zen Browser из flake `github:youwen5/zen-browser-flake` с runtime-обёрткой библиотек `ffmpeg_8` для поддержки видеокодеков H.264/AAC.

Для Google Chrome на NixOS разрешите несвободный пакет `google-chrome` в настройках nixpkgs.

На Mac с Apple Silicon Zen используется по умолчанию. Версия Zen и её зависимости закреплены в `inputs/flake.lock` этого модуля. Явно заданный хостом `inputs.zen-browser` по-прежнему переопределяет источник. На macOS Google Chrome и Tor Browser можно включить через `components.browsers.enabledPackages.google-chrome` и `components.browsers.enabledPackages.tor-browser`. Для них модуль использует casks Homebrew.

## Управление браузерами через MCP

Для Chrome используется официальный Chrome DevTools MCP, для Zen — WebDriver BiDi. В обоих браузерах можно управлять вкладками, переходить по URL, читать страницу, нажимать кнопки, заполнять поля, смотреть консоль, выполнять JavaScript в странице и делать снимки. В Chrome также доступны сетевые запросы и инструменты производительности. [Chrome DevTools MCP](https://github.com/ChromeDevTools/chrome-devtools-mcp) · [WebDriver BiDi](https://w3c.github.io/webdriver-bidi/)

Оба сервера по умолчанию выключены. Включите нужный браузер в том же элементе селектора, который подключает компонент.

```nix
((import (modulesRoot + "/browsers")).withConfig {
  home.components.browsers.mcp = {
    chrome.enable = true;
    zen.enable = true;
  };
})
```

Для каждого браузера задаются `port` (9222 для Chrome и 9223 для Zen), `profileDirectory` (по умолчанию под `xdg.stateHome/browser-mcp`) и `executable` (путь к браузеру или команда из PATH). MCP подключается к уже запущенному профилю на `127.0.0.1`. Чтобы открыть этот профиль, запустите вручную `chrome-mcp-browser` или `zen-mcp-browser`. [Требования Chrome к профилю для удалённой отладки](https://developer.chrome.com/blog/remote-debugging-port)

Для работы с обычными вкладками Zen полностью закройте браузер и запустите `zen-mcp-browser --default-profile`. Команда откроет стандартный профиль Zen с локальным WebDriver BiDi. При обычном запуске из меню приложений этот порт закрыт.

Home Manager регистрирует серверы `chrome` и `zen` в `programs.mcp.servers`. Для клиента со своим списком серверов используются stdio-команды `chrome-mcp` и `zen-mcp`. В Chrome начните с `list_pages` и `take_snapshot`. В Zen начните с `browser_tabs` и `browser_snapshot`. Список Zen включает вкладки с активными контекстами WebDriver BiDi. Выгруженная вкладка появляется в списке после загрузки. Снимок Zen возвращает CSS-селекторы элементов текущего документа для `browser_click` и `browser_type`.

Если Codex использует свой список серверов, после применения конфигурации регистрируйте нужные команды так:

```sh
codex mcp add chrome -- chrome-mcp
codex mcp add zen -- zen-mcp
```
