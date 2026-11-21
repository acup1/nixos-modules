# macOS keyboard

Глобальная перенастройка клавиатуры через Karabiner-Elements:

- Fn и левый Control меняются местами.
- Левые и правые Option/Command меняются местами.
- Caps Lock отключается.
- Нажатие Fn/Globe само по себе не переключает источник ввода.
- Ctrl+Space не перехватывается macOS для смены источника ввода.
- В GUI-приложениях стандартные Ctrl-сочетания работают как в Linux.
- В терминалах Ctrl+C/Ctrl+Z/Ctrl+D остаются управляющими сочетаниями, а
  копирование и вставка выполняются через Ctrl+Shift+C/Ctrl+Shift+V.
- Ctrl+стрелки, Ctrl+Backspace и Home/End используют Linux-подобную навигацию.

Переназначения применяются глобально. Терминальные приложения исключены из
преобразования Ctrl в Command, чтобы не ломать управление shell.

После первой установки macOS требует вручную разрешить Driver Extension и
Input Monitoring для Karabiner-Elements в System Settings → Privacy & Security.
