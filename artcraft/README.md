# ArtCraft Applications Suite

Модуль для установки полного набора творческих и офисных приложений от команды [ArtCraft](https://getartcraft.com/apps) (Storytold), написанных с нуля на чистом Rust:

1. **ArtCraft Launcher** (`artcraft-launcher`) — лаунчер и менеджер приложений
2. **PhotoCraft** (`photocraft`, `photocraft-cli`) — растровый графический редактор и работа с PSD/слоями
3. **VectorCraft** (`vectorcraft`, `vectorcraft-cli`) — векторная иллюстрация и графика
4. **FilmCraft** (`filmcraft`, `filmcraft-cli`) — нелинейный видеоредактор
5. **LightCraft** (`lightcraft`, `lightcraft-cli`) — неразрушающая обработка фото и RAW
6. **PdfCraft** (`pdfcraft`, `pdfcraft-cli`) — просмотр и редактирование PDF
7. **EffectCraft** (`effectcraft`, `effectcraft-cli`) — анимация, моушн-дизайн и композитинг
8. **DesignCraft** (`designcraft`, `designcraft-cli`) — верстка страниц и публикаций
9. **WordCraft** (`wordcraft`, `wordcraft-cli`) — текстовый процессор
10. **SoundCraft** (`soundcraft`, `soundcraft-cli`) — цифровая звуковая рабочая станция (DAW)
11. **DeckCraft** (`deckcraft`, `deckcraft-cli`) — презентации и слайды
12. **CADCraft** (`cadcraft`, `cadcraft-cli`) — САПР / CAD моделирование и черчение
13. **GridCraft** (`gridcraft`, `gridcraft-cli`) — электронные таблицы

## Использование

Подключите модуль в `modules.nix`:
```nix
(import (modulesRoot + "/artcraft"))
```
