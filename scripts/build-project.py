#!/usr/bin/env python3
"""
ConstructManager — интерактивная сборка Flutter проекта.
Выберите платформу и тип сборки.
"""

import re
import shutil
import subprocess
import sys
import os
import ctypes
from datetime import datetime
from pathlib import Path

PROJECT_DIR = Path(__file__).parent.parent / "client" / "construct_manager"
FLUTTER = "flutter"

PLATFORMS = {
    "1": {"name": "Android APK",     "cmd": ["build", "apk"]},
    "2": {"name": "Android AppBundle","cmd": ["build", "appbundle"]},
    "3": {"name": "iOS (требуется macOS)", "cmd": ["build", "ios"]},
    "4": {"name": "Web",             "cmd": ["build", "web"]},
    "5": {"name": "Windows (Desktop)","cmd": ["build", "windows"]},
    "6": {"name": "Linux (Desktop)",  "cmd": ["build", "linux"]},
    "7": {"name": "macOS (Desktop)",  "cmd": ["build", "macos"]},
}

BUILD_TYPES = {
    "1": {"name": "Debug",   "flag": "--debug"},
    "2": {"name": "Release", "flag": "--release"},
    "3": {"name": "Profile", "flag": "--profile"},
}


def _read_version() -> str:
    pubspec = PROJECT_DIR / "pubspec.yaml"
    if pubspec.exists():
        match = re.search(r"^version:\s*(\S+)", pubspec.read_text(encoding="utf-8"), re.MULTILINE)
        if match:
            ver = match.group(1)
            return ver.split("+")[0]
    return "1.0.0"


def clear():
    os.system("cls" if os.name == "nt" else "clear")


def print_header():
    clear()
    print("=" * 60)
    print("   ConstructManager — Flutter Build Tool")
    print("=" * 60)
    print()


def choose(options: dict, title: str) -> str:
    print(f"{title}:")
    print("-" * 40)
    for key, opt in options.items():
        print(f"  [{key}] {opt['name']}")
    print("-" * 40)

    while True:
        choice = input("  Выберите номер: ").strip()
        if choice in options:
            return choice
        print("  ❌ Неверный выбор. Попробуйте снова.\n")


def confirm_build(platform: str, build_type: str) -> bool:
    print()
    print("=" * 60)
    print(f"  Платформа:   {PLATFORMS[platform]['name']}")
    print(f"  Тип сборки:  {BUILD_TYPES[build_type]['name']}")
    print(f"  Директория:  {PROJECT_DIR}")
    print("=" * 60)
    print()
    ans = input("  Начать сборку? (Y/n): ").strip().lower() or "y"
    return ans == "y"


def run_build(platform: str, build_type: str):
    _kill_exe()

    if platform == "5":
        _fix_windows_ephemeral()

    _clean_project()

    cmd = [
        FLUTTER,
        *PLATFORMS[platform]["cmd"],
        BUILD_TYPES[build_type]["flag"],
    ]

    print()
    print(f"  ▶ Запуск: {' '.join(cmd)}")
    print()

    try:
        result = subprocess.run(
            cmd,
            cwd=str(PROJECT_DIR),
            shell=True,
        )
        if result.returncode == 0:
            print()
            if platform == "1":
                version = _read_version()
                build_flag = BUILD_TYPES[build_type]["flag"].lstrip("-")
                src = PROJECT_DIR / "build" / "app" / "outputs" / "flutter-apk" / f"app-{build_flag}.apk"
                dst = PROJECT_DIR / "build" / "app" / "outputs" / "flutter-apk" / f"ConstructionManager-v{version}.apk"
                if src.exists():
                    if dst.exists():
                        dst.unlink()
                    src.rename(dst)
                    print(f"  📦 APK: {dst}")
            now = datetime.now().strftime("%H:%M:%S")
            print(f"  ✅ Сборка успешно завершена! ({now})")
            _launch_app(platform, build_type)
        else:
            print()
            print(f"  ❌ Сборка завершилась с ошибкой (код: {result.returncode})")
    except FileNotFoundError:
        print("  ❌ Flutter не найден. Убедитесь, что Flutter установлен и добавлен в PATH.")
    except Exception as e:
        print(f"  ❌ Ошибка: {e}")

    print()
    # input("  Нажмите Enter, чтобы выйти...")


def _fix_windows_ephemeral():
    ephemeral_cc = PROJECT_DIR / "windows" / "flutter" / "ephemeral" / "cpp_client_wrapper" / "core_implementations.cc"
    if ephemeral_cc.exists():
        return
    build_cache = PROJECT_DIR / "build" / "windows" / "x64"
    if build_cache.exists():
        print("  🧹 Удаление устаревшего кэша сборки Windows...")
        shutil.rmtree(str(build_cache), ignore_errors=True)
    print("  ⚙ Синхронизация зависимостей...")
    try:
        subprocess.run(
            f"{FLUTTER} pub get",
            cwd=str(PROJECT_DIR),
            shell=True,
            capture_output=True,
            check=True,
        )
    except Exception:
        pass


def _clean_project():
    print("  🧹 Очистка кэша сборки (flutter clean)...")
    try:
        subprocess.run(
            [FLUTTER, "clean"],
            cwd=str(PROJECT_DIR),
            shell=True,
            capture_output=True,
            check=True,
        )
        print("  ✅ Кэш очищен")
    except Exception:
        print("  ⚠ Не удалось выполнить flutter clean (пропускаем)")


def _kill_exe():
    if os.name != "nt":
        return
    try:
        result = subprocess.run(
            ["taskkill", "/f", "/im", "construct_manager.exe"],
            capture_output=True, text=True, timeout=5,
        )
        if result.returncode == 0:
            print("  🔄 Предыдущий процесс construct_manager.exe завершён")
    except Exception:
        pass


def _launch_app(platform: str, build_type: str):
    build_mode = BUILD_TYPES[build_type]["flag"].lstrip("-").capitalize()
    exe_name = f"construct_manager.exe"
    exe_path = PROJECT_DIR / "build" / "windows" / "x64" / "runner" / build_mode / exe_name

    if not exe_path.exists():
        exe_path = PROJECT_DIR / "build" / "windows" / "x64" / build_mode / exe_name

    if exe_path.exists():
        print(f"  🚀 Запуск: {exe_path}")
        subprocess.Popen([str(exe_path)], cwd=str(exe_path.parent))


def main():
    if not PROJECT_DIR.exists():
        print(f"❌ Директория проекта не найдена: {PROJECT_DIR}")
        sys.exit(1)

    print_header()
    platform = choose(PLATFORMS, "Выберите платформу")
    build_type = choose(BUILD_TYPES, "Выберите тип сборки")

    if confirm_build(platform, build_type):
        run_build(platform, build_type)
        if os.name == "nt":
            ctypes.windll.user32.ShowWindow(
                ctypes.windll.kernel32.GetConsoleWindow(), 3
            )
    else:
        print("\n  Сборка отменена.")
        sys.exit(0)


if __name__ == "__main__":
    main()
