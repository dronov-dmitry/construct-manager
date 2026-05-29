"""
init-github.py

First-time initialization: pushes the entire project (dart/, database/,
dist/, scripts/) to a GitHub repository. The repo will host both GitHub
Pages (from dist/) and release builds (from dart/).

Requirements:
  - A GitHub repository must already exist (create via `gh repo create` or web UI)
  - The --repo-url must point to that repository

Usage:
    python scripts/init-github.py
    python scripts/init-github.py --repo-url https://github.com/user/repo.git
    python scripts/init-github.py --non-interactive
"""
from __future__ import annotations

import argparse
import subprocess
from pathlib import Path

from _common import Colors, log, parse_env_file, project_root, resolve_command, update_env_file

MANAGED_KEY = "GITHUB_REPO_URL"
MANAGED_LABEL = "GitHub repository URL"


def run_git(args: list[str], cwd: Path, *, check: bool = True) -> subprocess.CompletedProcess[str]:
    command = ["git", *args]
    log(f"$ {' '.join(command)}", Colors.GRAY)
    completed = subprocess.run(
        resolve_command(command),
        cwd=cwd,
        check=False,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    if completed.stdout.strip():
        print(completed.stdout, end="" if completed.stdout.endswith("\n") else "\n")
    if completed.stderr.strip():
        print(completed.stderr, end="" if completed.stderr.endswith("\n") else "\n")
    if check and completed.returncode != 0:
        raise RuntimeError(f"Git command failed: {' '.join(command)}")
    return completed


def detect_current_branch() -> str:
    result = subprocess.run(
        resolve_command(["git", "rev-parse", "--abbrev-ref", "HEAD"]),
        cwd=project_root(),
        capture_output=True,
        text=True,
    )
    return result.stdout.strip() or "main"


def ask_value(label: str, current: str = "") -> str:
    hint = f"[Enter = {current}]" if current else "[Enter = empty]"
    return input(f"{label} {Colors.GRAY}{hint}{Colors.RESET}: ").strip() or current


def load_repo_url(root: Path) -> str:
    return parse_env_file(root / ".env").get(MANAGED_KEY, "")


def save_repo_url(root: Path, value: str) -> None:
    update_env_file(root / ".env", {MANAGED_KEY: value})


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Initialize the entire project repository on GitHub."
    )
    parser.add_argument("--repo-url", default="", help="GitHub repository URL.")
    parser.add_argument("--remote-name", default="origin", help="Git remote name. Default: origin.")
    parser.add_argument("--non-interactive", action="store_true", help="Use provided values without prompts.")
    args = parser.parse_args()

    root = project_root()

    # Resolve repo URL
    repo_url = args.repo_url or load_repo_url(root)

    if not args.non_interactive:
        log("--- GitHub repository initialization ---", Colors.CYAN)
        repo_url = ask_value(MANAGED_LABEL, repo_url)

    if not repo_url:
        raise SystemExit("Repository URL is required.")

    log(f"Saving {MANAGED_KEY} to .env...", Colors.CYAN)
    save_repo_url(root, repo_url)

    # The root already has a git repo; ensure remote is configured
    current_url = run_git(["remote", "get-url", args.remote_name], root, check=False).stdout.strip()
    if current_url == repo_url:
        log(f"Remote '{args.remote_name}' already points to {repo_url}.", Colors.GREEN)
    elif current_url:
        log(f"Updating remote '{args.remote_name}'...", Colors.CYAN)
        run_git(["remote", "set-url", args.remote_name, repo_url], root)
    else:
        log(f"Adding remote '{args.remote_name}'...", Colors.CYAN)
        run_git(["remote", "add", args.remote_name, repo_url], root)

    # Remove detached dist/.git if present (from old init-github-frontend.py)
    dist_git = root / "dist" / ".git"
    if dist_git.exists():
        import shutil
        log("Removing isolated dist/.git (whole repo now uses root .git)...", Colors.YELLOW)
        shutil.rmtree(dist_git)

    # Ensure .gitignore ignores build artifacts
    gitignore = root / ".gitignore"
    required_rules = ["__pycache__", "*.pyc", ".env", ".dart_tool", ".idea", "build/", ".DS_Store"]
    if gitignore.exists():
        content = gitignore.read_text(encoding="utf-8")
        missing = [r for r in required_rules if r not in content]
        if missing:
            log("Adding missing .gitignore rules...", Colors.CYAN)
            with gitignore.open("a", encoding="utf-8") as f:
                f.write("\n# CI / build artifacts\n")
                for rule in missing:
                    f.write(f"{rule}\n")
    else:
        log("Creating .gitignore...", Colors.CYAN)
        gitignore.write_text("\n".join(required_rules) + "\n", encoding="utf-8")

    # Make sure we're on the right branch
    branch = detect_current_branch()
    log(f"Current branch: {branch}", Colors.CYAN)

    # Initial commit if needed
    status = run_git(["status", "--porcelain"], root).stdout.strip()
    has_commits = run_git(["rev-parse", "--verify", "HEAD"], root, check=False).returncode == 0

    if status or not has_commits:
        log("Creating initial commit...", Colors.CYAN)
        for folder in ["dart", "database", "dist", ".github", "README.md"]:
            run_git(["add", folder], root)
        if has_commits:
            run_git(["commit", "-m", "chore: initial project commit"], root)
        else:
            run_git(["commit", "--allow-empty", "-m", "chore: initial project commit"], root)
    else:
        log("No changes to commit.", Colors.GREEN)

    # Push
    log(f"Pushing branch '{branch}' to '{args.remote_name}'...", Colors.CYAN)
    run_git(["push", "-u", args.remote_name, branch], root)

    log("GitHub initialization completed.", Colors.GREEN)
    log("Next steps:", Colors.CYAN)
    log("  1. Enable GitHub Pages: Settings -> Pages -> Source: Deploy from a branch -> Branch: main -> Folder: /dist", Colors.YELLOW)
    log("  2. Run scripts/publish-github.py for the first release", Colors.YELLOW)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nInterrupted.")
    except Exception as e:
        print(f"\n{Colors.RED}{e}{Colors.RESET}")
        raise SystemExit(1)
