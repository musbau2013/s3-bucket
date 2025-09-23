

# Automated Semantic Versioning for Terraform Deployments

This repository uses **Conventional Commits** and GitHub Actions to automatically manage versioning and tagging of Terraform code deployments.

## 🚀 How It Works

1. **Commit Messages** follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.
2. **Pull Requests (PRs)** are merged into `main` only after review/approval.
3. Once merged, the workflow:

   * Analyzes commit messages since the last tag.
   * Determines the appropriate version bump:

     * **MAJOR** (`BREAKING CHANGE` or `!` in commit header)
     * **MINOR** (`feat:`)
     * **PATCH** (`fix:`)
     * **NO BUMP** (other commits like `docs:`, `chore:`, `refactor:` etc.)
   * Generates the next version following **SemVer (`vX.Y.Z`)**.
   * Creates and pushes a **git tag** for the new version.

This ensures that **trivial changes** (like updating comments, Terraform formatting, or `*` in IAM policy JSON) do **not** trigger a new release unless the commit type requires it.

---

## ✅ Example

Last release tag: `v1.2.3`

* Commit: `feat: add new S3 module` → Next tag: `v1.3.0`
* Commit: `fix: correct VPC peering config` → Next tag: `v1.2.4`
* Commit: `docs: update README` → No new tag
* Commit: `chore: format terraform code` → No new tag
* Commit: `refactor!: drop support for old provider` → Next tag: `v2.0.0`

---

## 📖 Commit Guidelines

Use the following commit types:

| Type                    | Release Impact | Example Commit Message                   |
| ----------------------- | -------------- | ---------------------------------------- |
| `feat`                  | MINOR bump     | `feat: add support for multi-account S3` |
| `fix`                   | PATCH bump     | `fix: correct IAM assume role policy`    |
| `chore`                 | none           | `chore: update Terraform lock file`      |
| `docs`                  | none           | `docs: add architecture diagram`         |
| `refactor`              | none           | `refactor: cleanup variables.tf`         |
| `test`                  | none           | `test: add module unit tests`            |
| `BREAKING CHANGE` / `!` | MAJOR bump     | `feat!: require Terraform 1.6+`          |

---

## ⚙️ Workflow Overview

The GitHub Actions workflow (`.github/workflows/version.yml`) runs **after a PR merge into main**:

1. Fetches the latest git tags.
2. Runs `version_script.py` to calculate the next version.
3. Creates a new git tag if applicable.
4. Pushes the tag back to GitHub.

---

## 🔧 Local Testing

To test versioning locally:

```bash
# Ensure git history has tags
git fetch --tags

# Run the script
python3 version_script.py
```

It will print the next version or indicate if no bump is required.

---

## 🔐 Notes for Terraform Repos

* Only commits with `feat:` or `fix:` (or breaking changes) will trigger new versions.
* Non-functional changes (`docs:`, `chore:`, `refactor:`, formatting, comments, IAM `*`) will **not** bump versions.
* Tags are used to version Terraform modules, providers, or infra changes consistently.

---

Would you like me to also add a **"Release Strategy" section** (e.g., how teams should cut releases for staging vs production Terraform deployments), or keep this README focused just on versioning?
