# ArtCraft Applications Suite

Модуль устанавливает готовые бинарные выпуски [ArtCraft](https://getartcraft.com/apps) из GitHub Releases. Сборка распаковывает проверенные по SHA-256 архивы. На NixOS она настраивает загрузчик и пути библиотек ELF. На macOS она сохраняет оригинальные подписанные `.app` и отдельно устанавливает выпущенные авторами CLI.

Доступны NixOS `x86_64-linux` и `aarch64-linux`, а также macOS `x86_64-darwin` и `aarch64-darwin`. macOS-архивы универсальные. Для лаунчера доступна команда `artcraft-launcher`. Остальные пакеты предоставляют приложение и одноимённую команду с суффиксом `-cli`.

| Приложение | Назначение | Выпуск |
| --- | --- | --- |
| ArtCraft Launcher | Менеджер приложений | [0.3.2](https://github.com/storytold/craft-launcher/releases/tag/v0.3.2) |
| PhotoCraft | Растровая графика и PSD | [0.7.0](https://github.com/storytold/photocraft/releases/tag/v0.7.0) |
| VectorCraft | Векторная графика | [0.9.0](https://github.com/storytold/vectorcraft/releases/tag/v0.9.0) |
| FilmCraft | Монтаж видео | [0.6.0](https://github.com/storytold/filmcraft/releases/tag/v0.6.0) |
| LightCraft | Обработка фотографий и RAW | [0.6.0](https://github.com/storytold/lightcraft/releases/tag/v0.6.0) |
| PdfCraft | Просмотр и редактирование PDF | [0.6.0](https://github.com/storytold/pdfcraft/releases/tag/v0.6.0) |
| EffectCraft | Анимация и композитинг | [0.8.0](https://github.com/storytold/effectcraft/releases/tag/v0.8.0) |
| DesignCraft | Вёрстка публикаций | [0.6.0](https://github.com/storytold/designcraft/releases/tag/v0.6.0) |
| WordCraft | Текстовые документы | [0.8.0](https://github.com/storytold/wordcraft/releases/tag/v0.8.0) |
| SoundCraft | Работа со звуком | [0.5.0](https://github.com/storytold/soundcraft/releases/tag/v0.5.0) |
| DeckCraft | Презентации | [0.5.0](https://github.com/storytold/deckcraft/releases/tag/v0.5.0) |
| CADCraft | САПР и черчение | [0.5.0](https://github.com/storytold/cadcraft/releases/tag/v0.5.0) |
| GridCraft | Электронные таблицы | [0.5.0](https://github.com/storytold/gridcraft/releases/tag/v0.5.0) |

## Использование

Добавьте `(import (modulesRoot + "/artcraft"))` в список `modules` файла `config.nix`. Параметры `components.artcraft.enabledPackages` позволяют отключить приложения в соответствующем слое.

```nix
((import (modulesRoot + "/artcraft")).withConfig {
  nixos.components.artcraft.enabledPackages.filmcraft = false;
  darwin.components.artcraft.enabledPackages.filmcraft = false;
})
```
