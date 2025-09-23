# import os
# import subprocess

# def get_latest_tag():
#     try:
#         # Fetch all tags from the remote
#         subprocess.run(["git", "fetch", "--tags"], check=True)
#         # Get the latest tag, sorting by version number
#         latest_tag = subprocess.check_output(
#             ["git", "describe", "--tags", "--abbrev=0", "HEAD"], text=True
#         ).strip()
#         return latest_tag
#     except subprocess.CalledProcessError:
#         print("No existing tags found. Starting at v0.0.0.")
#         return "v0.0.0"

# def calculate_next_version(latest_tag):
#     if latest_tag.startswith("v"):
#         latest_tag = latest_tag[1:]

#     parts = list(map(int, latest_tag.split('.')))
#     major, minor, patch = parts
    
#     # Implement your custom logic
#     if patch < 9:
#         patch += 1
#     elif minor < 9:
#         patch = 0
#         minor += 1
#     else:
#         patch = 0
#         minor = 0
#         major += 1

#     return f"v{major}.{minor}.{patch}"

# if __name__ == "__main__":
#     latest_tag = get_latest_tag()
#     next_version = calculate_next_version(latest_tag)

#     # Output the new version to an environment variable for the workflow
#     with open(os.environ['GITHUB_OUTPUT'], 'a') as fh:
#         print(f'next_version={next_version}', file=fh)

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
    bump = "patch"  # default
    for msg in commits:
        msg = msg.lower()
        if "breaking change" in msg:
            return "major"
        if msg.startswith("feat:") and bump != "major":
            bump = "minor"
        elif msg.startswith("fix:") and bump == "patch":
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
        return f"v{major}.{minor}.{patch}"


if __name__ == "__main__":
    version_type = os.getenv("VERSION_TYPE", "bump")
    manual_version = os.getenv("MANUAL_VERSION")

    latest_tag = get_latest_tag()
    major, minor, patch = parse_version(latest_tag)

    if version_type == "manual" and manual_version:
        next_version = manual_version
    else:
        commits = get_commits_since(latest_tag)
        if not commits:
            # No changes → keep the same version
            next_version = latest_tag
        else:
            bump = determine_bump(commits)
            next_version = bump_version(major, minor, patch, bump)

    with open(os.environ["GITHUB_OUTPUT"], "a") as fh:
        print(f"next_version={next_version}", file=fh)
