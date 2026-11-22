# Модуль `doc-redactors`

* **Экспорт**: `nixos`, `darwin`
* **Назначение**: Офисные редакторы, академическая верстка и работа с документами.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS и nix-darwin.
* `nixos.nix` — подключает `packages/`.
* `packages/doc_redactors.nix`:
  * Офисные пакеты: `libreoffice-qt-stable`, `wpsoffice-cn`.
  * Научная и техническая верстка: `typst`, полный дистрибутив `texliveFull`.
  * Просмотр и редактирование PDF: `xournalpp`, `pdfarranger`, `zathura`.
  * Ведение заметок и базы знаний: `obsidian`.

На macOS можно дополнительно включить WPS Office, PDF Arranger, Xournal++, Zathura и LibreOffice. Переключатель `libreoffice-qt-stable` устанавливает нативное приложение LibreOffice через Homebrew в nix-darwin и Qt-вариант в NixOS.
