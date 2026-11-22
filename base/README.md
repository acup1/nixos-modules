# Модуль `base`

Компонент устанавливает основные утилиты в NixOS и macOS.

- `packages/base.nix` подключает Git, Wget, Unzip, p7zip, fzf, bat, Neovim, Fastfetch, usbutils и Zsh. Применяются пакеты для целевой платформы. В macOS usbutils предоставляет `lsusb`.
- `nixos.nix` также подключает настройки Nix и бинарных кешей, NetworkManager, SSH, Zsh и системную обёртку `nh`. Каждый пакет можно отключить через `nixos.components.base.enabledPackages`.
- `darwin.nix` устанавливает утилиты в системный профиль. Для настройки рабочего стола и других системных предпочтений macOS используйте компонент `macos-base`.

На macOS включите `nh` или отключите отдельные инструменты через
`darwin.components.base.enabledPackages`.

```nix
(import ./base).withConfig {
  darwin.components.base.enabledPackages = {
    nh = true;
    fastfetch = false;
  };
}
```

В Darwin `components.base.enabledPackages.openssh` дополнительно устанавливает OpenSSH из nixpkgs.
