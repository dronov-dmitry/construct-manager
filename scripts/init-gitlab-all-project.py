from __future__ import annotations

import argparse
import subprocess
from pathlib import Path

from _common import Colors, ensure_project_layout, log, project_root, resolve_command


def ask_value(label: str, current: str = "") -> str:
    hint = f"[Enter = {current}]" if current else "[Enter = empty]"
    value = input(f"{label} {Colors.GRAY}{hint}{Colors.RESET}: ").strip()
    return value or current


def run_git(args: list[str], cwd: Path, *, check: bool = True) -> subprocess.CompletedProcess[str]:
    command = ["git", *args]
    display = " ".join(command)
    log(f"$ {display}", Colors.GRAY)

    completed = subprocess.run(
        resolve_command(command),
        cwd=cwd,
        check=False,
        shell=False,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )

    if completed.stdout.strip():
        print(completed.stdout, end="" if completed.stdout.endswith("\n") else "\n")
    if completed.stderr.strip():
        print(completed.stderr, end="" if completed.stderr.endswith("\n") else "\n")

    if check and completed.returncode != 0:
        raise RuntimeError(f"Git command failed: {display}")

    return completed


def git_output(args: list[str], cwd: Path) -> str:
    return run_git(args, cwd, check=False).stdout.strip()


def is_git_repo(root: Path) -> bool:
    completed = subprocess.run(
        resolve_command(["git", "rev-parse", "--is-inside-work-tree"]),
        cwd=root,
        check=False,
        shell=False,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    return completed.returncode == 0


def has_commits(root: Path) -> bool:
    completed = subprocess.run(
        resolve_command(["git", "rev-parse", "--verify", "HEAD"]),
        cwd=root,
        check=False,
        shell=False,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    return completed.returncode == 0


def ensure_git_repo(root: Path, branch: str) -> None:
    if is_git_repo(root):
        log("Git repository already initialized.", Colors.GREEN)
        return

    log("Initializing git repository...", Colors.CYAN)
    run_git(["init", "-b", branch], root)


def ensure_initial_commit(root: Path, message: str) -> None:
    status = git_output(["status", "--porcelain"], root)
    if not status and has_commits(root):
        log("No changes to commit.", Colors.GREEN)
        return

    log("Creating commit...", Colors.CYAN)
    run_git(["add", "."], root)

    if has_commits(root):
        run_git(["commit", "-m", message], root)
    else:
        run_git(["commit", "--allow-empty", "-m", message], root)


def configure_remote(root: Path, remote_name: str, repo_url: str) -> None:
    current_url = git_output(["remote", "get-url", remote_name], root)
    if current_url == repo_url:
        log(f"Remote '{remote_name}' already points to {repo_url}.", Colors.GREEN)
        return

    if current_url:
        log(f"Updating remote '{remote_name}'...", Colors.CYAN)
        run_git(["remote", "set-url", remote_name, repo_url], root)
        return

    log(f"Adding remote '{remote_name}'...", Colors.CYAN)
    run_git(["remote", "add", remote_name, repo_url], root)


def detect_branch(root: Path, default_branch: str) -> str:
    branch = git_output(["branch", "--show-current"], root)
    return branch or default_branch


def push_branch(root: Path, remote_name: str, branch: str) -> None:
    log(f"Pushing branch '{branch}' to '{remote_name}'...", Colors.CYAN)
    run_git(["push", "-u", remote_name, branch], root)


def main() -> None:
    parser = argparse.ArgumentParser(description="Initialize git, create a commit, and push to a remote repository.")
    parser.add_argument("--repo-url", default="", help="Remote repository URL.")
    parser.add_argument("--remote-name", default="gitlab", help="Git remote name. Default: gitlab (use 'origin' only if no GitHub remote exists).")
    parser.add_argument("--branch", default="main", help="Default branch name for a new repository.")
    parser.add_argument("--commit-message", default="chore: initial commit", help="Commit message.")
    parser.add_argument("--non-interactive", action="store_true", help="Use provided values without prompts.")
    args = parser.parse_args()

    root = project_root()
    ensure_project_layout()

    # Try to get repo_url from .env if not provided
    from _common import parse_env_file, update_env_file
    env_path = root / ".env"
    env_values = parse_env_file(env_path)
    
    repo_url = args.repo_url or env_values.get("GITLAB_REPO_URL", "")
    
    if not args.non_interactive:
        repo_url = ask_value("Repository URL", repo_url)

    if not repo_url:
        raise SystemExit("Repository URL is required.")

    # Save to .env for future use (e.g., publish-gitlab.py)
    log(f"Saving repository URL to {env_path}...", Colors.CYAN)
    update_env_file(env_path, {"GITLAB_REPO_URL": repo_url})

    ensure_git_repo(root, args.branch)
    ensure_initial_commit(root, args.commit_message)
    branch = detect_branch(root, args.branch)
    configure_remote(root, args.remote_name, repo_url)
    push_branch(root, args.remote_name, branch)

    log("Git initialization flow completed.", Colors.GREEN)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nInterrupted by user.")
    except Exception as error:
        print(f"\n{Colors.RED}Critical error: {error}{Colors.RESET}")
        raise SystemExit(1)
