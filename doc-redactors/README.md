# Модуль `doc-redactors`

* **Экспорт**: `nixos`
* **Назначение**: Офисные редакторы, академическая верстка и работа с документами.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/doc_redactors.nix`:
  * Офисные пакеты: `libreoffice-qt-stable`, `wpsoffice-cn`.
  * Научная и техническая верстка: `typst`, полный дистрибутив `texliveFull`.
  * Просмотр и редактирование PDF: `xournalpp`, `pdfarranger`, `zathura`.
  * Ведение заметок и базы знаний: `obsidian`.
