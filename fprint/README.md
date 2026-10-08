# Модуль `fprint`

* **Экспорт**: `nixos`
* **Назначение**: Аутентификация по сканеру отпечатков пальцев.

## Структура

* `default.nix` — экспортирует конфигурацию NixOS.
* `nixos.nix` — подключает `configuration/`.
* `configuration/fprint.nix`:
  * Интеграция с PAM: `security.pam.services.login.fprintAuth = true;` и `security.pam.services.sudo.fprintAuth = true;` для входа в систему и подтверждения `sudo` по отпечатку.
  * Заготовки конфигурации службы `fprintd` с драйверами (Goodix, Validity, Elan).
