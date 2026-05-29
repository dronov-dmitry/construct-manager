from __future__ import annotations

import os
import shutil
import subprocess
from pathlib import Path
from typing import Iterable, Sequence

BACKEND_HOST = "127.0.0.1"
BACKEND_PORT = 8787
FRONTEND_HOST = "localhost"
FRONTEND_PORT = 5173


class Colors:
    MAGENTA = "\033[95m"
    CYAN = "\033[96m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    GRAY = "\033[90m"
    BOLD = "\033[1m"
    RESET = "\033[0m"


def log(message: str, color: str = Colors.RESET) -> None:
    print(f"{color}{message}{Colors.RESET}")


def script_dir() -> Path:
    return Path(__file__).resolve().parent


def project_root() -> Path:
    return script_dir().parent


def worker_root() -> Path:
    return project_root() / "cloudflare-bot"


def server_root() -> Path:
    return project_root() / "server"


def database_root() -> Path:
    return server_root()


def dist_dir() -> Path:
    return worker_root() / "dist"


def backend_dev_vars_path() -> Path:
    return worker_root() / ".dev.vars"


def backend_dev_vars_example_path() -> Path:
    return worker_root() / ".dev.vars.example"


def root_package_json_path() -> Path:
    return worker_root() / "package.json"


def command_exists(name: str) -> bool:
    return shutil.which(name) is not None


def ensure_node() -> None:
    if not command_exists("node"):
        log("Node.js not found. Install Node.js 20+ and try again.", Colors.RED)
        raise SystemExit(1)

    try:
        version = subprocess.check_output(["node", "-v"], text=True).strip()
        major = int(version.lstrip("v").split(".")[0])
        if major < 20:
            log(f"Node.js 20+ is required. Current version: {version}", Colors.RED)
            raise SystemExit(1)
        log(f"Node.js detected: {version}", Colors.GREEN)
    except Exception as error:
        log(f"Failed to detect Node.js version: {error}", Colors.RED)
        raise SystemExit(1)


def pnpm_command() -> list[str]:
    if command_exists("pnpm"):
        return ["pnpm"]
    if command_exists("corepack"):
        return ["corepack", "pnpm"]
    log("pnpm was not found. Install pnpm or enable it via corepack.", Colors.RED)
    raise SystemExit(1)


def ensure_project_layout() -> None:
    required_paths = [
        project_root() / "dart" / "construct_manager" / "pubspec.yaml",
        project_root() / "database" / "001-schema.sql",
        project_root() / "dist" / "index.html",
        project_root() / ".github" / "workflows" / "pages.yml",
    ]
    missing = [str(path) for path in required_paths if not path.exists()]
    if missing:
        log("Project layout looks incomplete:", Colors.RED)
        for path in missing:
            log(f"  - {path}", Colors.RED)
        raise SystemExit(1)


def resolve_command(command: Sequence[str]) -> list[str]:
    if not command:
        raise ValueError("Command must not be empty")

    if os.name != "nt":
        return list(command)

    executable = shutil.which(command[0])
    if executable:
        return [executable, *command[1:]]
    return list(command)


def run(
    command: Sequence[str],
    *,
    cwd: Path | None = None,
    check: bool = True,
    env: dict[str, str] | None = None,
    capture_output: bool = False,
) -> subprocess.CompletedProcess:
    display = " ".join(str(part) for part in command)
    log(f"$ {display}", Colors.GRAY)

    # Для Windows используем правильную кодировку
    if os.name == 'nt':
        completed = subprocess.run(
            resolve_command(command),
            cwd=cwd or project_root(),
            check=False,
            shell=False,
            env=env,
            capture_output=capture_output,
            text=True,
            encoding='utf-8',
            errors='replace'  # Заменяем нечитаемые символы
        )
    else:
        completed = subprocess.run(
            resolve_command(command),
            cwd=cwd or project_root(),
            check=False,
            shell=False,
            env=env,
            capture_output=capture_output,
            text=True,
            encoding='utf-8',
            errors='ignore'
        )

    if check and completed.returncode != 0:
        log(f"Command failed with exit code {completed.returncode}: {display}", Colors.RED)
        raise SystemExit(completed.returncode)
    return completed


def install_command() -> list[str]:
    return [*pnpm_command(), "install"]


def ensure_dependencies(*, force: bool = False) -> None:
    node_modules_dir = project_root() / "node_modules"
    if force or not node_modules_dir.exists():
        log("Installing workspace dependencies...", Colors.CYAN)
        run(install_command(), cwd=project_root())
    else:
        log("Workspace dependencies already installed.", Colors.GREEN)


def dependencies_installed() -> bool:
    return (project_root() / "node_modules").exists()


def run_root_script(script: str, extra_args: Iterable[str] | None = None, *, env: dict[str, str] | None = None) -> None:
    run([*pnpm_command(), script, *(list(extra_args or []))], cwd=project_root(), env=env)


def run_workspace_script(
    workspace: str,
    script: str,
    extra_args: Iterable[str] | None = None,
    *,
    env: dict[str, str] | None = None,
) -> None:
    run(
        [*pnpm_command(), "--filter", workspace, script, *(list(extra_args or []))],
        cwd=project_root(),
        env=env,
    )


def backend_base_url() -> str:
    return f"http://{BACKEND_HOST}:{BACKEND_PORT}"


def backend_api_base_url() -> str:
    return f"{backend_base_url()}/api"


def frontend_base_url() -> str:
    return f"http://{FRONTEND_HOST}:{FRONTEND_PORT}"


def parse_env_file(path: Path) -> dict[str, str]:
    if not path.exists():
        return {}

    values: dict[str, str] = {}
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip().strip('"').strip("'")
    return values


def update_env_file(path: Path, updates: dict[str, str]) -> None:
    existing = []
    if path.exists():
        existing = path.read_text(encoding="utf-8").splitlines()

    new_lines: list[str] = []
    updated_keys: set[str] = set()

    for line in existing:
        stripped = line.strip()
        if stripped and not stripped.startswith("#") and "=" in stripped:
            key = stripped.split("=", 1)[0].strip()
            if key in updates:
                new_lines.append(f"{key}={updates[key]}")
                updated_keys.add(key)
                continue
        new_lines.append(line)

    for key, value in updates.items():
        if key not in updated_keys:
            if new_lines and new_lines[-1].strip():
                new_lines.append("")
            new_lines.append(f"{key}={value}")

    path.write_text("\n".join(new_lines).rstrip() + "\n", encoding="utf-8")
