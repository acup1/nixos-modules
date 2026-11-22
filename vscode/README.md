# Модуль `vscode`

* **Экспорт**: `home`
* **Назначение**: Полная конфигурация редактора Visual Studio Code в профиле пользователя.

## Структура

* `default.nix` — экспортирует конфигурацию Home Manager.
* `home.nix` — подключает модули из `home_packages/`.
* `home_packages/vscode/default.nix`:
  * Сборка и интеграция локального расширения тем `acup-local-colorways`.
  * Настройка Vim-режима (расширение VSCodeVim): перемещения, кастомные привязки клавиш.
  * Удобные хоткеи открытия/скрытия интегрированного терминала (`Ctrl+\`).
  * Параметры форматирования кода, шрифты и тема оформления.

## Настройки

`components.vscode.theme` выбирает цветовую тему для стандартного профиля VS Code. По умолчанию используется `Ocean High Contrast`.

```nix
components.vscode = {
  theme = "Ember";
  enabledPackages.vim = false;
};
```

Расширения VSCodeVim, Codex и Local Colorways управляются переключателями `enabledPackages.vim`, `enabledPackages.codex` и `enabledPackages.local-colorways`. Codex доступен на Linux и macOS с процессорами x86-64 и ARM64. Он включён по умолчанию на Mac с Apple Silicon. Для Intel Mac используйте nixpkgs 26.05.

Если отключить Local Colorways, вместо любой темы из его набора редактор выберет встроенную `Default High Contrast`. Для темы из стороннего расширения задайте `programs.vscode.profiles.default.userSettings."workbench.colorTheme"` и добавьте расширение в `programs.vscode.profiles.default.extensions`.

При поддержке MCP в Home Manager редактор получает серверы из `programs.mcp.servers`. Чтобы отключить эту интеграцию, задайте `programs.vscode.profiles.default.enableMcpIntegration = false`.
