# Модуль `kicad`

Компонент подключает KiCad для проектирования схем и печатных плат. В
Linux пакет из nixpkgs включён по умолчанию и управляется переключателем
`home.components.kicad.enabledPackages.kicad`. В macOS управление
официальным приложением через Homebrew можно включить отдельно.
[Cask KiCad](https://formulae.brew.sh/cask/kicad)

```nix
(import ./kicad).withConfig {
  darwin.components.kicad.enabledPackages.kicad = true;
}
```

## KiCad MCP

Локальный stdio-сервер включается отдельно от GUI. Он может
использовать уже установленный KiCad.

```nix
(import ./kicad).withConfig {
  home.components.kicad.mcp = {
    enable = true;
    projectsDirectory = "/home/user/projects";
  };
}
```

При наличии `programs.mcp` Home Manager добавляет сервер `kicad` в
реестр. Для ручной настройки клиента укажите команду
`kicad-mcp --root /путь/к/проектам` с транспортом stdio. Если каталог не задан, сервер использует рабочий каталог
клиента. Инструменты принимают относительные пути внутри этого каталога.

- `list_project_files` показывает файлы проекта, платы и схемы, а также подкаталоги.
- `inspect_project_settings` возвращает версию формата, классы сетей и имена
  текстовых переменных из файла `.kicad_pro`.
- `check_board_drc` и `check_schematic_erc` запускают штатные проверки KiCad
  и возвращают отчёт JSON. В Linux сервер использует `kicad-cli` из nixpkgs.
  В macOS он ищет CLI в `/Applications/KiCad/KiCad.app/Contents/MacOS`.
  Для другой локальной установки укажите абсолютный путь в
  `home.components.kicad.mcp.cliExecutable`.
  [Документация KiCad CLI](https://docs.kicad.org/master/en/cli/cli.html)

Проверки создают отчёты во временном каталоге. Просмотр проектов доступен
и без `kicad-cli`.
