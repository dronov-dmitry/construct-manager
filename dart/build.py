#!/usr/bin/env python3
"""
ConstructManager — интерактивная сборка Flutter проекта.
Выберите платформу и тип сборки.
"""

import subprocess
import sys
import os
from pathlib import Path

PROJECT_DIR = Path(__file__).parent / "construct_manager"
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
    ans = input("  Начать сборку? (y/n): ").strip().lower()
    return ans == "y"


def run_build(platform: str, build_type: str):
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
            print("  ✅ Сборка успешно завершена!")
        else:
            print()
            print(f"  ❌ Сборка завершилась с ошибкой (код: {result.returncode})")
    except FileNotFoundError:
        print("  ❌ Flutter не найден. Убедитесь, что Flutter установлен и добавлен в PATH.")
    except Exception as e:
        print(f"  ❌ Ошибка: {e}")

    print()
    input("  Нажмите Enter, чтобы выйти...")


def main():
    if not PROJECT_DIR.exists():
        print(f"❌ Директория проекта не найдена: {PROJECT_DIR}")
        sys.exit(1)

    print_header()
    platform = choose(PLATFORMS, "Выберите платформу")
    build_type = choose(BUILD_TYPES, "Выберите тип сборки")

    if confirm_build(platform, build_type):
        run_build(platform, build_type)
    else:
        print("\n  Сборка отменена.")
        sys.exit(0)


if __name__ == "__main__":
    main()
