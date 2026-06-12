from __future__ import annotations

import argparse
import subprocess
from pathlib import Path

from _common import Colors, ensure_project_layout, log, parse_env_file, project_root, run

MANAGED_KEY = "GITLAB_REPO_URL"
MANAGED_LABEL = "GitLab remote or URL"


def load_publish_config(root: Path) -> dict[str, str]:
    env_path = root / ".env"
    return parse_env_file(env_path)


def update_publish_config(root: Path, value: str) -> None:
    env_path = root / ".env"
    lines: list[str] = []
    found = False
    existing = env_path.read_text(encoding="utf-8").splitlines() if env_path.exists() else []

    for line in existing:
        stripped = line.strip()
        if stripped and not stripped.startswith("#") and "=" in stripped:
            key = stripped.split("=", 1)[0].strip()
            if key == MANAGED_KEY:
                if value:
                    lines.append(f"{MANAGED_KEY}={value}")
                found = True
                continue
        lines.append(line)

    if value and not found:
        if lines and lines[-1].strip():
            lines.append("")
        lines.append(f"{MANAGED_KEY}={value}")

    env_path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


def git_output(args: list[str], cwd: Path) -> str:
    completed = subprocess.run(
        ["git", *args],
        cwd=cwd,
        check=False,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    return (completed.stdout or "").strip()


def git_remote_exists(name: str, cwd: Path) -> bool:
    if not name or "://" in name or name.startswith("git@"):
        return False
    completed = subprocess.run(["git", "remote", "get-url", name], cwd=cwd, check=False, capture_output=True, text=True)
    return completed.returncode == 0


def looks_like_repo_url(value: str) -> bool:
    return value.startswith("http://") or value.startswith("https://") or value.startswith("git@")


def ask_value(label: str, current: str = "") -> str:
    hint = f"[Enter = {current}]" if current else "[Enter = empty]"
    value = input(f"{label} {Colors.GRAY}{hint}{Colors.RESET}: ").strip()
    return value or current


def get_user_config(root: Path, *, non_interactive: bool, override: str) -> str:
    current = load_publish_config(root).get(MANAGED_KEY, "")
    value = override or current

    if non_interactive:
        update_publish_config(root, value)
        return value

    log("--- GitLab publish target ---", Colors.CYAN)
    value = ask_value(MANAGED_LABEL, value)
    update_publish_config(root, value)
    return value


def ensure_git_repo(root: Path) -> None:
    if not (root / ".git").exists():
        raise RuntimeError("Current project is not a git repository.")


def remove_gitignored_from_tracking(root: Path) -> None:
    """Remove files that are in .gitignore but still present in the committed tree."""
    result = subprocess.run(
        ["git", "ls-files", "-i", "--cached", "--exclude-standard"],
        cwd=root,
        check=False,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    should_remove = [f.strip() for f in (result.stdout or "").splitlines() if f.strip()]

    if should_remove:
        log(f"Removing {len(should_remove)} gitignored file(s) from git tracking...", Colors.YELLOW)
        
        # Windows has a command line limit (~8191 chars). 
        # We chunk the file list to stay well within limits.
        chunk_size = 50 
        for i in range(0, len(should_remove), chunk_size):
            chunk = should_remove[i : i + chunk_size]
            log(f"  untracking batch {i//chunk_size + 1} ({len(chunk)} files)...", Colors.GRAY)
            run(["git", "rm", "--cached", "--ignore-unmatch", "--", *chunk], cwd=root)


def maybe_commit_changes(root: Path, message: str, *, skip_commit: bool) -> None:
    remove_gitignored_from_tracking(root)

    status = git_output(["status", "--porcelain"], root)
    if not status:
        log("Нет изменений для коммита.", Colors.GREEN)
        return

    if skip_commit:
        log("Есть изменения, но --skip-commit включен.", Colors.YELLOW)
        return

    log("Создаем коммит перед публикацией...", Colors.CYAN)
    log(f"   Сообщение коммита: {message}", Colors.GRAY)
    
    # Показываем что будет закоммичено
    changed_files = status.split('\n')
    log(f"   Измененных файлов: {len(changed_files)}", Colors.GRAY)
    for i, file_status in enumerate(changed_files[:5]):  # Показываем первые 5 файлов
        if file_status:
            log(f"   - {file_status}", Colors.GRAY)
    if len(changed_files) > 5:
        log(f"   ... и еще {len(changed_files) - 5} файлов", Colors.GRAY)
    
    # Ensure scripts/ is staged (excluded from GitHub but should go to GitLab)
    run(["git", "add", "scripts/"], cwd=root)
    run(["git", "add", "-A"], cwd=root)
    run(["git", "commit", "-m", message], cwd=root)


def push_target(root: Path, target: str, branch: str) -> None:
    if not target:
        log("Skipping GitLab push: target not configured.", Colors.YELLOW)
        return

    if not looks_like_repo_url(target) and not git_remote_exists(target, root):
        raise RuntimeError(f"GitLab target '{target}' is not a git remote and is not a URL.")

    log(f"Pushing branch '{branch}' to GitLab: {target}", Colors.CYAN)
    
    # Если target это URL, добавляем временный remote
    if looks_like_repo_url(target):
        temp_remote = "gitlab-publish-temp"
        # Удаляем временный remote если он уже существует
        subprocess.run(["git", "remote", "remove", temp_remote], cwd=root, check=False, capture_output=True)
        # Добавляем временный remote
        run(["git", "remote", "add", temp_remote, target], cwd=root)
        push_to = temp_remote
    else:
        push_to = target
    
    # Пушим ветку
    run(["git", "push", "--force", "-u", push_to, branch], cwd=root)
    
    # Если использовали временный remote, удаляем его
    if looks_like_repo_url(target):
        subprocess.run(["git", "remote", "remove", "gitlab-publish-temp"], cwd=root, check=False, capture_output=True)
def main() -> None:
    parser = argparse.ArgumentParser(description="Push the current branch to GitLab.")
    parser.add_argument("--non-interactive", action="store_true")
    parser.add_argument("--skip-commit", action="store_true")
    parser.add_argument("--gitlab-remote", default="", help="GitLab remote or repository URL.")
    parser.add_argument("--branch", default="", help="Branch to push. Defaults to current branch.")
    parser.add_argument("--commit-message", default="chore: publish updates")
    args = parser.parse_args()

    root = project_root()
    
    ensure_project_layout()
    ensure_git_repo(root)

    gitlab_target = get_user_config(root, non_interactive=args.non_interactive, override=args.gitlab_remote)

    # Note: Build step removed as per user request. 
    # This script now focuses strictly on git synchronization.

    maybe_commit_changes(root, args.commit_message, skip_commit=args.skip_commit)

    branch = args.branch or git_output(["branch", "--show-current"], root) or "main"
    push_target(root, gitlab_target, branch)

    log("GitLab publish flow completed.", Colors.GREEN)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nInterrupted by user.")
    except Exception as error:
        print(f"\n{Colors.RED}Critical error: {error}{Colors.RESET}")
        raise SystemExit(1)
