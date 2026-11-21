# macOS tiling

Тайлинг для macOS на базе yabai и skhd с комбинациями из `WM-DE/niri`.

`Mod` в конфигурации — левый Command. Вместе с `macos-keyboard` это
физический Option. `Ctrl` после перестановки — физический Fn.

Основные комбинации:

- `Mod` + стрелки — фокус окна.
- `Mod+Ctrl+H/J/K/L` или стрелки — перемещение окна в BSP-дереве.
- `Mod+Shift+стрелки` — фокус монитора.
- `Mod+Shift+K/L` — уменьшить/увеличить громкость.
- `Mod+Ctrl+Shift+H/J/K/L` — перенос окна на монитор.
- `Mod+1..9` — Space; `Mod+Shift+1..9` — перенос окна.
- `Mod+Page Down/Page Up` — следующий/предыдущий Space.
- `Mod+I` — предыдущий Space.
- `Mod+U` — приложение Screenshot.
- `Mod+-/=` — ширина; с Shift — высота.
- `Mod+F` — maximize; `Mod+Shift+F` — fullscreen zoom.
- `F14` — переключить окно между floating и tiling. С `macos-keyboard` работает и `Mod+V`.
- `Mod` + перетаскивание левой кнопкой — перемещение окна из любой его точки; правой кнопкой — изменение размера.
- `F13` — закрыть окно под курсором и сфокусировать окно под курсором в том же Space. С `macos-keyboard` работает и `Mod+C`.
- `Mod+Q` — новое окно Ghostty.
- С `macos-keyboard` сочетание `Mod+X` открывает Spotlight, а `Mod+Space` переключает раскладку клавиатуры.
- `Mod+Shift+/` — окно со списком основных сочетаний.

Сочетания `Mod+1..9` работают только для уже созданных macOS Spaces. Без
Scripting Addition yabai намеренно не создаёт недостающие Spaces автоматически.

Если приложение навязывает минимальный размер и его окно начинает перекрывать
соседей, модуль автоматически объединяет новое окно в stack с самой большой
BSP-областью. То же происходит после появления пятой отдельной области на
текущем Space: это не даёт приложениям ломать раскладку на встроенном экране.

Базовый BSP-тайлинг, управление окнами и переключение Spaces работают с
включённым SIP. Scripting Addition намеренно отключён: для него требуется
частично отключать System Integrity Protection из Recovery Mode.

DankMaterialShell не запускается на macOS: это Linux/Wayland shell, завязанный
на Quickshell, Wayland compositor и Linux desktop services.
