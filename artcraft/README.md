# ArtCraft Applications Suite

Модуль устанавливает готовые бинарные выпуски [ArtCraft](https://getartcraft.com/apps) из GitHub Releases. Сборка распаковывает проверенные по SHA-256 архивы. На NixOS она настраивает загрузчик и пути библиотек ELF. На macOS она сохраняет оригинальные подписанные `.app` и отдельно устанавливает выпущенные авторами CLI.

Доступны NixOS `x86_64-linux` и `aarch64-linux`, а также macOS `x86_64-darwin` и `aarch64-darwin`. macOS-архивы универсальные. Для лаунчера доступна команда `artcraft-launcher`. Остальные пакеты предоставляют приложение и одноимённую команду с суффиксом `-cli`.

| Приложение | Назначение | Выпуск |
| --- | --- | --- |
| ArtCraft Launcher | Менеджер приложений | [0.19.2](https://github.com/storytold/craft-launcher/releases/tag/v0.19.2) |
| PhotoCraft | Растровая графика и PSD | [0.23.1](https://github.com/storytold/photocraft/releases/tag/v0.23.1) |
| VectorCraft | Векторная графика | [0.24.1](https://github.com/storytold/vectorcraft/releases/tag/v0.24.1) |
| FilmCraft | Монтаж видео | [0.20.1](https://github.com/storytold/filmcraft/releases/tag/v0.20.1) |
| LightCraft | Обработка фотографий и RAW | [0.21.1](https://github.com/storytold/lightcraft/releases/tag/v0.21.1) |
| PdfCraft | Просмотр и редактирование PDF | [0.21.1](https://github.com/storytold/pdfcraft/releases/tag/v0.21.1) |
| EffectCraft | Анимация и композитинг | [0.24.1](https://github.com/storytold/effectcraft/releases/tag/v0.24.1) |
| DesignCraft | Вёрстка публикаций | [0.20.1](https://github.com/storytold/designcraft/releases/tag/v0.20.1) |
| WordCraft | Текстовые документы | [0.18.1](https://github.com/storytold/wordcraft/releases/tag/v0.18.1) |
| SoundCraft | Работа со звуком | [0.20.1](https://github.com/storytold/soundcraft/releases/tag/v0.20.1) |
| DeckCraft | Презентации | [0.18.1](https://github.com/storytold/deckcraft/releases/tag/v0.18.1) |
| CADCraft | САПР и черчение | [0.20.1](https://github.com/storytold/cadcraft/releases/tag/v0.20.1) |
| GridCraft | Электронные таблицы | [0.19.1](https://github.com/storytold/gridcraft/releases/tag/v0.19.1) |

## Использование

Добавьте `(import (modulesRoot + "/artcraft"))` в список `modules` файла `config.nix`. Параметры `components.artcraft.enabledPackages` позволяют отключить приложения в соответствующем слое.

```nix
((import (modulesRoot + "/artcraft")).withConfig {
  nixos.components.artcraft.enabledPackages.filmcraft = false;
  darwin.components.artcraft.enabledPackages.filmcraft = false;
})
```
