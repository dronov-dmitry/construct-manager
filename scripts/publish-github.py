"""
publish-github.py

Subsequent release publishing: bumps app version, combines SQL files,
commits changes, creates a git tag, and pushes everything to GitHub.
A GitHub Actions workflow (release.yml) will then build Flutter artifacts
for all platforms and upload them to the release.

Usage:
    python scripts/publish-github.py
    python scripts/publish-github.py --non-interactive
    python scripts/publish-github.py --tag v1.2.3
"""
from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

from _common import Colors, log, parse_env_file, project_root, resolve_command, update_env_file

MANAGED_KEY = "GITHUB_REPO_URL"


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
        errors="replace",
    )
    if completed.stdout.strip():
        print(completed.stdout, end="" if completed.stdout.endswith("\n") else "\n")
    if completed.stderr.strip():
        print(completed.stderr, end="" if completed.stderr.endswith("\n") else "\n")
    if check and completed.returncode != 0:
        raise RuntimeError(f"Git command failed: {' '.join(command)}")
    return completed


def ask_value(label: str, current: str = "") -> str:
    hint = f"[Enter = {current}]" if current else "[Enter = empty]"
    return input(f"{label} {Colors.GRAY}{hint}{Colors.RESET}: ").strip() or current


def detect_current_branch() -> str:
    result = subprocess.run(
        resolve_command(["git", "rev-parse", "--abbrev-ref", "HEAD"]),
        cwd=project_root(),
        capture_output=True,
        text=True,
    )
    return result.stdout.strip() or "main"


def latest_remote_tag(repo_url: str) -> str:
    completed = run_git(["ls-remote", "--tags", "--refs", repo_url], project_root(), check=False)
    tags: list[tuple[int, int, int, str]] = []

    for line in completed.stdout.splitlines():
        ref = line.rsplit("/", 1)[-1].strip()
        match = re.fullmatch(r"v?(\d+)\.(\d+)\.(\d+)", ref)
        if match:
            tags.append((int(match.group(1)), int(match.group(2)), int(match.group(3)), ref))

    if not tags:
        return "v0.0.0"

    tags.sort()
    return tags[-1][3]


def next_tag(current: str) -> str:
    match = re.fullmatch(r"v?(\d+)\.(\d+)\.(\d+)", current)
    if not match:
        return "v1.0.0"
    return f"v{int(match.group(1))}.{int(match.group(2))}.{int(match.group(3)) + 1}"


def update_pubspec_version(pubspec_path: Path, version: str) -> None:
    if not pubspec_path.exists():
        log(f"pubspec.yaml not found at {pubspec_path}, skipping version bump.", Colors.YELLOW)
        return
    content = pubspec_path.read_text(encoding="utf-8")
    new_content = re.sub(
        r"^version:\s*.*$",
        f"version: {version}",
        content,
        count=1,
        flags=re.MULTILINE,
    )
    pubspec_path.write_text(new_content, encoding="utf-8")
    log(f"Updated pubspec.yaml version to {version}", Colors.GREEN)


def run_combine_sql(root: Path) -> None:
    script = root / "scripts" / "combine-sql.py"
    if not script.exists():
        log("scripts/combine-sql.py not found, skipping SQL combine.", Colors.YELLOW)
        return
    log("Running scripts/combine-sql.py...", Colors.CYAN)
    result = subprocess.run(
        [sys.executable, str(script)],
        cwd=root,
        capture_output=True,
        text=True,
    )
    if result.stdout:
        print(result.stdout)
    if result.returncode != 0:
        log(f"combine-sql.py failed:\n{result.stderr}", Colors.RED)
        raise SystemExit(1)
    log("SQL files combined.", Colors.GREEN)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Publish a new release: bump version, combine SQL, push tag."
    )
    parser.add_argument("--non-interactive", action="store_true")
    parser.add_argument("--repo-url", default="", help="GitHub repository URL.")
    parser.add_argument("--branch", default="", help="Branch to push (auto-detected if empty).")
    parser.add_argument("--commit-message", default="chore: publish release")
    parser.add_argument("--tag", default="", help="Release tag (auto-incremented from GitHub tags if empty).")
    args = parser.parse_args()

    root = project_root()

    repo_url = args.repo_url or parse_env_file(root / ".env").get(MANAGED_KEY, "")
    if not args.non_interactive:
        repo_url = ask_value("GitHub repository URL", repo_url)
    if not repo_url:
        log("GitHub repository URL is required.", Colors.RED)
        sys.exit(1)

    update_env_file(root / ".env", {MANAGED_KEY: repo_url})

    # Determine tag
    tag = args.tag or next_tag(latest_remote_tag(repo_url))
    pubspec_version = tag.lstrip("v")

    log(f"Release tag: {tag}", Colors.CYAN)

    # 1. Combine SQL files
    run_combine_sql(root)

    # 2. Bump version in pubspec.yaml
    pubspec = root / "client" / "construct_manager" / "pubspec.yaml"
    update_pubspec_version(pubspec, pubspec_version)

    # 3. Commit everything
    branch = args.branch or detect_current_branch()
    log(f"Committing on branch '{branch}'...", Colors.CYAN)
    for folder in ["client", "database", "dist", ".github", "README.md"]:
        run_git(["add", folder], root)
    status = run_git(["status", "--porcelain"], root).stdout.strip()

    if status:
        run_git(["commit", "-m", f"{args.commit_message} {tag}"], root)
        run_git(["push", "-u", "origin", branch], root)
    else:
        log("No changes to commit.", Colors.GREEN)

    # 4. Tag and push
    log(f"Creating and pushing tag {tag}...", Colors.CYAN)
    run_git(["tag", "-f", tag], root)
    run_git(["push", "--force", "origin", tag], root)

    log(f"Release {tag} published!", Colors.GREEN)
    log("GitHub Actions will now build Flutter artifacts for all platforms.", Colors.CYAN)
    log("Check progress at: Actions -> Release build", Colors.YELLOW)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nInterrupted.")
    except Exception as e:
        print(f"\n{Colors.RED}{e}{Colors.RESET}")
        sys.exit(1)
