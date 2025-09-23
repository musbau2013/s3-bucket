import os
import subprocess

def get_latest_tag():
    try:
        subprocess.run(["git", "fetch", "--tags"], check=True)
        latest_tag = subprocess.check_output(
            ["git", "describe", "--tags", "--abbrev=0"], text=True
        ).strip()
        return latest_tag
    except subprocess.CalledProcessError:
        return "v0.0.0"

def parse_version(tag):
    if tag.startswith("v"):
        tag = tag[1:]
    major, minor, patch = map(int, tag.split("."))
    return major, minor, patch

def get_commits_since(tag):
    try:
        commits = subprocess.check_output(
            ["git", "log", f"{tag}..HEAD", "--pretty=%s"], text=True
        ).strip().split("\n")
        return [c.strip() for c in commits if c.strip()]
    except subprocess.CalledProcessError:
        return []

def determine_bump(commits):
    """
    Determines the version bump based strictly on Conventional Commits:
    - BREAKING CHANGE → major
    - feat: → minor
    - fix: → patch
    Commits that don't match these prefixes are ignored (no bump)
    """
    bump = None
    for msg in commits:
        msg_lower = msg.lower()
        if "breaking change" in msg_lower:
            return "major"
        if msg_lower.startswith("feat:"):
            bump = "minor"
        elif msg_lower.startswith("fix:") and bump != "minor":
            bump = "patch"
    return bump

def bump_version(major, minor, patch, bump):
    if bump == "major":
        return f"v{major + 1}.0.0"
    elif bump == "minor":
        return f"v{major}.{minor + 1}.0"
    elif bump == "patch":
        return f"v{major}.{minor}.{patch + 1}"
    else:
        # No bump (all commits ignored)
        return f"v{major}.{minor}.{patch}"

if __name__ == "__main__":
    latest_tag = get_latest_tag()
    major, minor, patch = parse_version(latest_tag)

    commits = get_commits_since(latest_tag)
    bump = determine_bump(commits)
    next_version = bump_version(major, minor, patch, bump)

    with open(os.environ["GITHUB_OUTPUT"], "a") as fh:
        print(f"next_version={next_version}", file=fh)
