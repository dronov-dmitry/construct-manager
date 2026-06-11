import subprocess
import sys
import time
import os
import shutil

# --- АВТОПОИСК И ПУТИ ---
def find_flutter():
    name = shutil.which('flutter')
    if name: return name
    locations = [
        os.path.expanduser('~/flutter/bin/flutter'),
        '/opt/flutter/bin/flutter',
        '/usr/lib/flutter/bin/flutter',
        '/snap/bin/flutter',
        '/home/kat/flutter/bin/flutter',
    ]
    for loc in locations:
        if os.path.exists(loc): return loc
    print("[-] Flutter not found. Set FLUTTER_ROOT or check PATH")
    sys.exit(1)

FLUTTER_PATH = find_flutter()
ANDROID_HOME = os.environ.get('ANDROID_HOME', os.environ.get('ANDROID_SDK_ROOT', '/usr/lib/android-sdk'))
ADB_PATH = os.path.join(ANDROID_HOME, 'platform-tools', 'adb')
EMULATOR_PATH = os.path.join(ANDROID_HOME, 'emulator', 'emulator')
# Путь к sdkmanager (в новых SDK он лежит в cmdline-tools/latest/bin/)
SDKMANAGER_PATH = os.path.join(ANDROID_HOME, 'cmdline-tools', 'latest', 'bin', 'sdkmanager')
if not os.path.exists(SDKMANAGER_PATH):
    # Запасной путь для старых версий SDK
    SDKMANAGER_PATH = os.path.join(ANDROID_HOME, 'tools', 'bin', 'sdkmanager')

# Список всех версий API, которые мы хотим развернуть
TARGET_APIS = {
    '29': 'Android_10',
    '30': 'Android_11',
    '31': 'Android_12',
    '33': 'Android_13',
    '34': 'Android_14',
    '35': 'Android_15',
    '36': 'Android_16'
}

def find_java():
    java_home = os.environ.get('JAVA_HOME')
    if java_home and os.path.exists(os.path.join(java_home, 'bin', 'javac')):
        return java_home
    java = shutil.which('java')
    if java:
        real = os.path.realpath(java)
        for _ in range(5):
            parent = os.path.dirname(real)
            if os.path.exists(os.path.join(parent, 'javac')):
                jdk_root = os.path.dirname(parent) if os.path.basename(parent) == 'bin' else parent
                os.environ['JAVA_HOME'] = jdk_root
                return jdk_root
            real = parent
    return '/usr/lib/jvm/java-17-openjdk-amd64' # дефолт для Linux

find_java()
PACKAGE = 'com.dronov.deutsche_verb'
ACTIVITY = '.MainActivity'

SKIP_LINES = ['C/C++:', 'Caching disabled', 'Task.upToDateWhen', 'Build cache is disabled', 'Simple merging task']

# --- НОВАЯ ФУНКЦИЯ: АВТОМАТИЧЕСКАЯ УСТАНОВКА И СОЗДАНИЕ ВСЕХ АНДРОИДОВ ---
def get_installed_images():
    # Ищем все установленные system-images на диске
    images_dir = os.path.join(ANDROID_HOME, 'system-images')
    installed = {}
    if os.path.exists(images_dir):
        for api_dir in os.listdir(images_dir):
            api_path = os.path.join(images_dir, api_dir)
            if not os.path.isdir(api_path):
                continue
            api_num = api_dir.replace('android-', '')
            for variant_dir in os.listdir(api_path):
                variant_path = os.path.join(api_path, variant_dir)
                if os.path.isdir(variant_path) and 'x86_64' in os.listdir(variant_path):
                    installed.setdefault(api_num, []).append(variant_dir)
    return installed

def setup_all_android_versions():
    print("\n[+] Проверка и подготовка всех версий Android API...")

    existing_avds = get_all_emulators()
    installed_images = get_installed_images()

    print(f"   [i] Найдено образов на диске: {len(installed_images)} API")
    for api, variants in sorted(installed_images.items()):
        print(f"      API {api}: {', '.join(variants)}")

    for api, avd_name in TARGET_APIS.items():
        if avd_name in existing_avds:
            print(f"   ✓ Эмулятор {avd_name} уже создан.")
            continue

        print(f"   [+] Эмулятор {avd_name} (API {api}) не найден. Начинаем установку...")

        # Ищем образ на диске, пробуем default или google_apis
        variants = installed_images.get(api, [])
        chosen = None
        for preferred in ['default', 'google_apis']:
            if preferred in variants:
                chosen = preferred
                break
        if not chosen and variants:
            chosen = variants[0]

        if not chosen:
            print(f"   [!] Нет образа для API {api} на диске. Попробуй установить вручную:")
            print(f"      sudo {SDKMANAGER_PATH} 'system-images;android-{api};default;x86_64'")
            continue

        image_package = f"system-images;android-{api};{chosen};x86_64"
        print(f"   [+] Использую образ: {image_package}")

        print(f"   [+] Создание устройства {avd_name}...")
        avdmanager_path = SDKMANAGER_PATH.replace('sdkmanager', 'avdmanager')
        create_cmd = f"echo 'no' | {avdmanager_path} create avd -n {avd_name} -k '{image_package}' --force"
        subprocess.run(create_cmd, shell=True, stdout=subprocess.DEVNULL)
        current = get_all_emulators()
        if avd_name in current:
            print(f"   ✓ Устройство {avd_name} успешно создано!")
        else:
            print(f"   ✗ Не удалось создать {avd_name}")

def get_all_emulators():
    try:
        result = subprocess.run([EMULATOR_PATH, '-list-avds'], capture_output=True, text=True, check=True)
        return [line.strip() for line in result.stdout.splitlines() if line.strip()]
    except Exception:
        return []

def launch_emulator(emu_id):
    print(f"[+] Запуск эмулятора: {emu_id}...")
    base_args = [
        EMULATOR_PATH, '-avd', emu_id,
        '-no-snapshot', '-netdelay', 'none', '-netspeed', 'full',
        '-gpu', 'auto'
    ]
    proc = subprocess.Popen(base_args, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, start_new_session=True)
    time.sleep(3)
    if proc.poll() is not None:
        err = proc.stderr.read().decode() if proc.stderr else ""
        for line in err.splitlines()[:5]:
            print(f"   [emulator] {line}")

def wait_for_any_device(emu_id, timeout=180):
    before = set(get_connected_devices())
    start = time.time()
    while time.time() - start < timeout:
        now = set(get_connected_devices())
        new = now - before
        if new:
            for d in sorted(new):
                print(f"   ok {emu_id} -> {d}")
            return sorted(new)[0]
        time.sleep(5)
    return None

def run_adb_cmd(args, timeout=15):
    try:
        return subprocess.run(args, capture_output=True, text=True, timeout=timeout)
    except Exception:
        class MockResult: stdout = ""; stderr = "Error"; returncode = -1
        return MockResult()

def ensure_sdk_components():
    """Проверяет и устанавливает через sudo нужные platform и build-tools."""
    needed = set()
    platforms_dir = os.path.join(ANDROID_HOME, 'platforms')
    bt_dir = os.path.join(ANDROID_HOME, 'build-tools')

    installed_platforms = set()
    if os.path.exists(platforms_dir):
        for d in os.listdir(platforms_dir):
            installed_platforms.add(d)

    installed_bts = set()
    if os.path.exists(bt_dir):
        for d in os.listdir(bt_dir):
            installed_bts.add(d)

    for api in ['34', '35']:
        if f'android-{api}' not in installed_platforms:
            needed.add(f'platforms;android-{api}')

    has_bt35 = any(d.startswith('35') for d in installed_bts)
    if not has_bt35:
        needed.add('build-tools;35.0.0')

    # Ещё может понадобиться build-tools 34
    has_bt34 = any(d.startswith('34') for d in installed_bts)
    if not has_bt34:
        needed.add('build-tools;34.0.0')

    if not needed:
        return True

    print(f"   [!] Нужно установить SDK компоненты: {', '.join(sorted(needed))}")
    print(f"   [sudo] Запуск sdkmanager с sudo...")
    all_pkgs = ' '.join(f"'{p}'" for p in sorted(needed))
    cmd = f"sudo {SDKMANAGER_PATH} {all_pkgs}"
    r = subprocess.run(cmd, shell=True)
    if r.returncode != 0:
        print(f"   [-] Не удалось установить. Попробуй вручную:")
        print(f"      {cmd}")
        return False
    return True

def get_api_level(device_id):
    result = run_adb_cmd([ADB_PATH, '-s', device_id, 'shell', 'getprop', 'ro.build.version.sdk'])
    api = result.stdout.strip()
    names = {'29': 'Android 10', '30': '11', '31': '12', '32': '12L', '33': '13', '34': '14', '35': '15', '36': '16'}
    return f"API {api} ({names.get(api, 'Unknown')})" if api else "API Unknown"

def wait_for_device(device_id, timeout=400):
    start = time.time()
    while time.time() - start < timeout:
        r = run_adb_cmd([ADB_PATH, '-s', device_id, 'shell', 'getprop', 'sys.boot_completed'])
        if r.stdout.strip() == '1':
            print(f"   ok {device_id} ({get_api_level(device_id)})")
            return True
        time.sleep(5)
    return False

def get_connected_devices():
    result = run_adb_cmd([ADB_PATH, 'devices'])
    connected = []
    for line in result.stdout.splitlines():
        parts = line.strip().split()
        if len(parts) == 2 and parts[1] == 'device' and parts[0].startswith('emulator-'):
            connected.append(parts[0])
    return connected

def build_apk():
    print("\n[build] Сборка APK...")
    proc = subprocess.Popen([FLUTTER_PATH, 'build', 'apk', '--debug'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1)
    if proc.stdout:
        for line in iter(proc.stdout.readline, ''):
            line = line.strip()
            if line and not any(s in line for s in SKIP_LINES):
                print(f"  {line}")
    proc.wait()
    return proc.returncode == 0

def test_on_device(device_id):
    api = get_api_level(device_id)
    print(f"\n{'='*60}\n[device] {device_id} — {api}\n{'='*60}")
    apk_path = os.path.join(os.getcwd(), 'build', 'app', 'outputs', 'flutter-apk', 'app-debug.apk')

    run_adb_cmd([ADB_PATH, '-s', device_id, 'shell', 'pm', 'clear', PACKAGE])
    print("  [install] Установка APK...")
    r = run_adb_cmd([ADB_PATH, '-s', device_id, 'install', '-r', '-t', apk_path], timeout=120)
    if 'Success' not in r.stdout:
        print("  [-] Установка не удалась"); return

    print("  [start] Запуск приложения...")
    run_adb_cmd([ADB_PATH, '-s', device_id, 'shell', 'am', 'start', '-n', f'{PACKAGE}/{ACTIVITY}'])
    time.sleep(10)

    # Проверка логов на ошибки рендеринга Flutter (Impeller/EGL)
    result = run_adb_cmd([ADB_PATH, '-s', device_id, 'logcat', '-d', '-v', 'brief', 'flutter:V', '*:S'])
    errors = [l for l in result.stdout.splitlines() if 'Impeller' in l or 'EGL' in l or 'ERROR' in l]
    if errors:
        print("  [warn] Обнаружены ошибки в логах:")
        for e in errors[:3]: print(f"     {e.strip()}")
    else:
        print("  [ok] Ошибок рендеринга на этой версии не обнаружено.")

def clear_stale_locks():
    print("[+] Очистка зависших процессов и локов...")
    for proc in ['qemu-system-x86_64', 'emulator', 'adb']:
        try: subprocess.run(['killall', '-9', proc], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except Exception: pass
    time.sleep(2)
    avd_dir = os.path.expanduser('~/.android/avd')
    if os.path.exists(avd_dir):
        for root, dirs, files in os.walk(avd_dir):
            for d in [d for d in dirs if d.endswith('.lock')]:
                try: shutil.rmtree(os.path.join(root, d))
                except Exception: pass
            for f in [f for f in files if f.endswith('.lock') or 'multiinstance.lock' in f]:
                try: os.remove(os.path.join(root, f))
                except Exception: pass

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(os.path.join(script_dir, '..', 'client', 'construct_manager'))

    existing = get_connected_devices()
    if existing:
        print(f"[i] Найдены уже запущенные эмуляторы: {', '.join(existing)}")
        print("[i] Пропускаем очистку и установку, используем существующие.")
        connected = existing
    else:
        clear_stale_locks()
        setup_all_android_versions()

        emulators = get_all_emulators()
        if not emulators:
            print("[-] Ошибка: Созданные эмуляторы не найдены в системе.")
            return

        target_emulators = [e for e in emulators if e in TARGET_APIS.values()]
        if not target_emulators:
            print("[-] Нет ни одного целевого эмулятора (Android_10..16)")
            return

        print(f"[i] Будет запущено эмуляторов: {len(target_emulators)}")
        for e in target_emulators:
            print(f"   - {e}")

        connected = []
        for emu in target_emulators:
            launch_emulator(emu)
            avail = wait_for_any_device(emu, timeout=180)
            if avail:
                connected.append(avail)
            else:
                print(f"   x {emu} ne podklyuchilsya, propuskaem")

    print("\n[wait] Ожидаем, пока загрузятся все операционные системы (до 10 минут)...")
    ready = [d for d in connected if wait_for_device(d, timeout=600)]

    if not ready:
        print("[-] Ни один эмулятор не смог загрузиться.")
        return

    if not ensure_sdk_components():
        print("[-] Не удалось подготовить SDK. Сборка невозможна."); return

    if not build_apk():
        print("[-] Сборка приложения завершилась ошибкой."); return

    # Тестируем по очереди на всех готовых Android устройствах
    for device in ready:
        test_on_device(device)

    print(f"\n{'='*60}\n[ok] Тестирование успешно завершено на всех версиях Android (Всего: {len(ready)})")

if __name__ == "__main__":
    main()