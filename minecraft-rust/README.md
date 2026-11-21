# Minecraft на Rust

Модуль устанавливает игровой клиент Horizon и его лаунчер для Mac с Apple Silicon. Добавьте `(import (modulesRoot + "/minecraft-rust"))` в `modules` своего `config.nix` и примените конфигурацию.

Команда `minecraft-rust` открывает лаунчер. Для первой игры понадобится учётная запись Microsoft с Minecraft Java Edition и локальная копия версии 26.3. Команда `minecraft-rust versions --installed` показывает доступные лаунчеру сборки. Если список пуст, установите закреплённую версию командой `minecraft-rust install nightly-2026-11-21`. Затем выберите **Prepare** и **Play**. Игровой бинарник из Nix доступен как `horizon-client`. [Инструкция Horizon](https://playhorizon.dev/docs/install)
