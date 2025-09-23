import os
import subprocess

def get_latest_tag():
    try:
        # Fetch all tags from the remote
        subprocess.run(["git", "fetch", "--tags"], check=True)
        # Get the latest tag, sorting by version number
        latest_tag = subprocess.check_output(
            ["git", "describe", "--tags", "--abbrev=0", "HEAD"], text=True
        ).strip()
        return latest_tag
    except subprocess.CalledProcessError:
        print("No existing tags found. Starting at v0.0.0.")
        return "v0.0.0"

def calculate_next_version(latest_tag):
    if latest_tag.startswith("v"):
        latest_tag = latest_tag[1:]

    parts = list(map(int, latest_tag.split('.')))
    major, minor, patch = parts
    
    # Implement your custom logic
    if patch < 9:
        patch += 1
    elif minor < 9:
        patch = 0
        minor += 1
    else:
        patch = 0
        minor = 0
        major += 1

    return f"v{major}.{minor}.{patch}"

if __name__ == "__main__":
    latest_tag = get_latest_tag()
    next_version = calculate_next_version(latest_tag)

    # Output the new version to an environment variable for the workflow
    with open(os.environ['GITHUB_OUTPUT'], 'a') as fh:
        print(f'next_version={next_version}', file=fh)
