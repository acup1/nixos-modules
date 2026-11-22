# Модуль `dev`

* **Экспорт**: `nixos`, `darwin`
* **Назначение**: Комплект компиляторов, языков программирования и инструментов сборки.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS и nix-darwin.
* `nixos.nix` — подключает `packages/`.
* `packages/dev.nix`:
  * C/C++: `gcc`, `libgccjit`, `clang`, `cling`
  * Rust: `rustc`, `cargo`, `rustup`
  * Go: `go`
  * Python: `python3`
  * JavaScript/Web: `nodejs`
  * Embedded: `arduino-ide`
  * Сборка и документация: `gnumake`, `scdoc`

На macOS в `components.dev.enabledPackages` можно дополнительно включить `gcc`, `libgccjit`, `rustup`, `scdoc` и `arduino-ide`. Arduino IDE устанавливается через Homebrew.

При одновременной установке `cc` и `c++` продолжают указывать на Clang. Чтобы прокси Rustup управляли командами `rustc` и `cargo`, отключите одноимённые пакеты в этом модуле.
