import os
import subprocess
import platform

# 1. Получаем абсолютный путь к папке, где лежит этот скрипт
script_dir = os.path.dirname(os.path.abspath(__file__))

# 2. Поднимаемся на одну папку выше
parent_dir = os.path.abspath(os.path.join(script_dir, os.path.pardir))

# Определяем операционную систему
is_windows = platform.system() == "Windows"

print(f"=== Управление opencode Code ({'Windows' if is_windows else 'Linux'}) ===")
print("1. Запустить opencode (в родительской папке, на весь экран) [По умолчанию]")
print("2. Войти в профиль (opencode auth login, на весь экран)")
print("3. Выйти из профиля (opencode auth logout, на весь экран)")
print("============================")

# choice = input("Выберите действие (1, 2 или 3): ").strip()
choice = "1"

def enable_windows_shortcuts():
    """Включает поддержку Ctrl+C / Ctrl+V в Windows Console навсегда"""
    try:
        import winreg
        key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Console", 0, winreg.KEY_SET_VALUE)
        # InterceptCopyPaste = 1 активирует Ctrl+C и Ctrl+V в cmd
        winreg.SetValueEx(key, "InterceptCopyPaste", 0, winreg.REG_DWORD, 1)
        winreg.CloseKey(key)
    except Exception:
        pass

def enable_linux_shortcuts():
    """Включает сочетания клавиш Ctrl+Shift+C/V в gnome-terminal навсегда"""
    try:
        schema = "org.gnome.Terminal.Legacy.Settings"
        key = "shortcuts-enabled"
        result = subprocess.run(["gsettings", "get", schema, key], capture_output=True, text=True)
        if "false" in result.stdout.lower():
            subprocess.run(["gsettings", "set", schema, key, "true"])
    except Exception:
        pass

def run_in_new_terminal(command, working_dir=None, maximize=False):
    """
    Запускает команду в новом окне с предварительной настройкой горячих клавиш.
    """
    if is_windows:
        # Принудительно проверяем реестр перед запуском cmd
        enable_windows_shortcuts()
        
        cmd_parts = ["cmd", "/c", "start", '""']
        if maximize:
            cmd_parts.append("/max")
            
        if working_dir:
            internal_command = f'cmd /k "cd /d ""{working_dir}"" && {command}"'
        else:
            internal_command = f'cmd /k "{command}"'
            
        cmd_parts.append(internal_command)
        subprocess.Popen(" ".join(cmd_parts), shell=True)
    else:
        # Принудительно проверяем gsettings перед запуском gnome-terminal
        enable_linux_shortcuts()
        
        args = ['gnome-terminal']
        if maximize:
            args.append('--maximize')
        if working_dir:
            args.append(f'--working-directory={working_dir}')
        
        args.extend(['--', 'bash', '-c', f'{command}; exec bash'])
        subprocess.Popen(args)

if choice == "" or choice == "1":
    run_in_new_terminal('opencode', working_dir=parent_dir, maximize=True)
    print(f"\n[Успешно] Скрипт лежит в: {script_dir}")
    print(f"[Успешно] opencode запущен на уровень выше: {parent_dir}")

elif choice == "2":
    print("\nЗапуск процесса авторизации...")
    run_in_new_terminal('opencode auth login', maximize=True)
    print("[Успешно] Окно авторизации открыто. Следуйте инструкциям на экране.")

elif choice == "3":
    print("\nВыполняется выход из профиля opencode Code...")
    run_in_new_terminal('opencode auth logout', maximize=True)
    print("[Успешно] Команда разлогина отправлена в новое окно.")

else:
    print("\n[Ошибка] Неверный ввод. Пожалуйста, запустите скрипт снова и выберите 1, 2 или 3.")