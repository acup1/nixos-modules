# Модуль `dev`

* **Экспорт**: `nixos`
* **Назначение**: Комплект компиляторов, языков программирования и инструментов сборки.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `packages/`.
* `packages/dev.nix`:
  * C/C++: `gcc`, `libgccjit`, `clang`, `cling`
  * Rust: `rustc`, `cargo`, `rustup`
  * Go: `go`
  * Python: `python3`
  * JavaScript/Web: `nodejs`
  * Embedded: `arduino-ide`
  * Сборка и документация: `gnumake`, `scdoc`
