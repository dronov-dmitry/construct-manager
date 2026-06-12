from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

from _common import Colors, log, project_root


def run_script(script_name: str, args: list[str]) -> None:
    script = project_root() / "scripts" / script_name
    cmd = [sys.executable, str(script), *args]
    log(f"Running: {' '.join(cmd)}", Colors.CYAN)
    result = subprocess.run(cmd, check=False, capture_output=False)
    if result.returncode != 0:
        log(f"Script {script_name} failed with exit code {result.returncode}", Colors.RED)
        sys.exit(result.returncode)


def main() -> None:
    parser = argparse.ArgumentParser(description="Publish to GitHub (client+database) and GitLab (full project).")
    parser.add_argument("--github-url", default="", help="GitHub repository URL.")
    parser.add_argument("--gitlab-url", default="", help="GitLab repository URL.")
    parser.add_argument("--branch", default="main")
    parser.add_argument("--commit-message", default="chore: publish updates")
    parser.add_argument("--tag", default="", help="GitHub release tag. Auto-incremented if omitted.")
    parser.add_argument("--skip-github", action="store_true")
    parser.add_argument("--skip-gitlab", action="store_true")
    args = parser.parse_args()

    script_args: list[str] = ["--non-interactive", "--branch", args.branch, "--commit-message", args.commit_message]

    if not args.skip_github:
        gh_args = [*script_args]
        if args.github_url:
            gh_args += ["--repo-url", args.github_url]
        if args.tag:
            gh_args += ["--tag", args.tag]
        run_script("publish-github.py", gh_args)

    if not args.skip_gitlab:
        gl_args = [*script_args]
        if args.gitlab_url:
            gl_args += ["--gitlab-remote", args.gitlab_url]
        run_script("publish-gitlab.py", gl_args)

    log("Both remotes updated.", Colors.GREEN)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nInterrupted.")
    except Exception as e:
        print(f"\n{Colors.RED}{e}{Colors.RESET}")
        sys.exit(1)
