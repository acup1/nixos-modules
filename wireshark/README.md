# Wireshark

Компонент устанавливает Wireshark с графическим интерфейсом для NixOS и macOS. По умолчанию захват доступен пользователю `username` из селектора. Изменение группы может потребовать нового входа в систему.

```nix
((import (modulesRoot + "/wireshark")).withConfig {
  darwin.components.wireshark.capture.users = [ "alice" ];
  nixos.components.wireshark.capture.enable = false;
  home.components.wireshark.mcp = {
    enable = true;
    captureDirectory = "/path/to/captures";
    liveCapture.enable = true;
  };
})
```

На NixOS доступ выдаёт системный модуль Wireshark через группу `wireshark` и обёртку `dumpcap`. На Darwin за устройства BPF отвечает демон `wireshark-chmodbpf`. Он запускает ChmodBPF из исходников той же версии Wireshark с выделенной группой `_nix_wireshark`. Если уже запущен официальный ChmodBPF, демон подключает выделенную группу к существующей группе доступа. При выгрузке он отзывает выданный им доступ. Пустой список пользователей выключает эту настройку. [Документация Wireshark о захвате в macOS](https://www.wireshark.org/docs/wsug_html_chunked/ChBuildInstallOSXInstall.html)

По умолчанию MCP выключен. При включении Home Manager регистрирует `wireshark` в `programs.mcp.servers` и устанавливает команду `wireshark-mcp`. Если `captureDirectory` пуст, инструменты используют рабочий каталог клиента. Каталог для записи должен существовать.

## Захват PCAP и проверка DSCP

1. Включите `mcp.liveCapture.enable`, чтобы открыть инструменты `capture_interfaces` и `capture_pcap`. Интерфейс можно передать при вызове или задать через `mcp.liveCapture.interface`.
2. Перед входом в тестовый звонок откройте `chrome://webrtc-internals` в Chrome или `about:webrtc` в Zen и запустите `capture_pcap` на 30–45 секунд. Укажите новое имя с расширением `.pcap` или `.pcapng`. При первом замере оставьте оба транспорта, например передайте BPF-фильтр `udp or tcp`. Во время записи включите звук и видео. Для проверки кодеков сопоставьте `codecId` входящих и исходящих RTP-потоков со статистикой `codec`.
3. Найдите в записи транспорт, IP и порт выбранной ICE-пары. Для прямого UDP-потока пример фильтра Wireshark выглядит как `udp && ip.addr == 192.0.2.10 && udp.port == 1030`, где IP и порт нужно заменить значениями из звонка. Если один адрес и порт разделяют несколько потоков, добавьте адрес и порт с другой стороны. Для TURN используйте видимый в PCAP поток до relay. При работе через VPN смотрите захват на туннельном интерфейсе для разметки пакетов звонка и на физическом для разметки внешнего туннеля.
4. Передайте этот display filter в `capture_dscp`, чтобы получить количество пакетов по значениям DSCP во внешнем IP-заголовке. Параметр `local_address` добавляет разбивку на входящие и исходящие пакеты по локальному IP из PCAP. Вызов `export_capture` с тем же фильтром сохраняет пакеты в отдельную запись.
