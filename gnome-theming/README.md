# gnome-theming

Добавьте `(import (modulesRoot + "/gnome-theming"))` в список модулей для пользователя GNOME. Home Manager установит расширения и запишет их UUID в `org.gnome.shell enabled-extensions`.

Набор включает AppIndicator and KStatusNotifierItem Support, Blur my Shell, Dash to Dock, Desktop Icons NG (DING), Desktop Widgets (Desktop Clock), Rounded Corners и Tray Icons: Reloaded. Версии двух последних расширений в nixpkgs для GNOME 51 объявляют совместимость только до GNOME 50. [Rounded Corners](https://extensions.gnome.org/extension/1514/rounded-corners/) · [Tray Icons: Reloaded](https://extensions.gnome.org/extension/2890/tray-icons-reloaded/)
