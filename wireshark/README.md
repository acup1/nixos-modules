# Wireshark

Компонент устанавливает Wireshark с графическим интерфейсом для NixOS и macOS. По умолчанию захват доступен пользователю `username` из селектора. Изменение группы может потребовать нового входа в систему.

```nix
((import (modulesRoot + "/wireshark")).withConfig {
  darwin.components.wireshark.capture.users = [ "alice" ];
  nixos.components.wireshark.capture.enable = false;
  home.components.wireshark.mcp = {
    enable = true;
    captureDirectory = "/path/to/captures";
  };
})
```

На NixOS доступ выдаёт системный модуль Wireshark через группу `wireshark` и обёртку `dumpcap`. На Darwin за устройства BPF отвечает демон `wireshark-chmodbpf`. Он запускает ChmodBPF из исходников той же версии Wireshark с выделенной группой `_nix_wireshark`. Если уже запущен официальный ChmodBPF, демон подключает выделенную группу к существующей группе доступа. При выгрузке он отзывает выданный им доступ. Пустой список пользователей выключает эту настройку. [Документация Wireshark о захвате в macOS](https://www.wireshark.org/docs/wsug_html_chunked/ChBuildInstallOSXInstall.html)

По умолчанию MCP выключен. При включении Home Manager регистрирует `wireshark` в `programs.mcp.servers` и устанавливает команду `wireshark-mcp`. Инструменты `capture_summary` и `protocol_hierarchy` читают файлы записей из указанного каталога. Для запуска вручную каталог задаёт переменная `WIRESHARK_MCP_ROOT` либо рабочий каталог клиента.
