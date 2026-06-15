# Work Template Docs

This repository is a reusable template for documentation-first projects.

Use it as a starting point for collecting vendor documentation, internal notes,
and operational references for the software or service being documented.

## Structure

| Folder | Purpose |
| ------ | ------- |
| [docs/](docs/) | Documentation index for the docs area and subfolders |
| [docs/diagrams/](docs/diagrams/) | Diagram source files, including Ilograph workspace overviews |
| [docs/internal/](docs/internal/) | Internal notes, decisions, and meeting records |
| [docs/vendor/](docs/vendor/) | Vendor-supplied documentation, manuals, and reference material |
| [images/](images/) | Supporting screenshots and diagrams |
| [src/](src/) | Runtime service logic (rule loading, matching, mailbox polling, message filing) |
| [test/](test/) | Focused unit tests for rules and service behavior |

## Tooling

| File/Folder | Purpose |
| ----------- | ------- |
| [.githooks/](.githooks/) | Git hook scripts used for pre-commit and pre-push validation |
| [.github/instructions/](.github/instructions/) | Repository instructions used by Copilot and other tooling |
| [.github/workflows/](.github/workflows/) | GitHub Actions workflows used for automated repository validation |
| [.vscode/](.vscode/) | Workspace settings and extension recommendations for contributors |
| [scripts/](scripts/) | Utility scripts used by hooks (settings/extensions/word-list sorting) |
| [.markdownlint.yaml](.markdownlint.yaml) | Shared markdownlint rule configuration used by the pre-commit hook |
| [.markdownlintignore](.markdownlintignore) | Ignore rules for transient markdown artifacts such as .tmp/ output |
| [Makefile](Makefile) | Optional shortcuts for hook setup, sorting, and docs linting |
| [package.json](package.json) | Generic Node metadata and markdownlint-cli2 development dependency |

## Quick Start

```bash
make init
make lint-docs
```

`make init` is the recommended first-run bootstrap command. It configures Git
hooks (`core.hooksPath=.githooks`), normalizes VS Code workspace files, and
updates `package.json` metadata (`name`, `description`) from template defaults
to repository-derived values. It also creates/updates a project-specific cSpell
word list in `.vscode/` and registers it in
`cSpell.customDictionaries` automatically. Documentation placeholders such as
`{{PROJECT_NAME}}` under [docs/](docs/) are also replaced with the project
name derived from the repository folder (with a leading `work-` prefix removed).

Git does not allow a repository template to enforce local `.git/config` values
automatically, so this bootstrap step must be run once per cloned/generated
repository.

## Automatic Branch Deletion for Template-Based Repositories

`Automatically delete head branches` is a per-repository GitHub setting. It is
not inherited automatically by repositories created from this template.

If you create a new repository from `techie2000/work-template-docs` **using the
GitHub CLI template flow**, set `delete_branch_on_merge=true` immediately after
creation.

If you created the repository by clicking **Use this template** in the GitHub
web UI, do **not** run the `gh repo create` command below. That command creates
another repository; it does not update the one you already made in the browser.

### GitHub CLI template creation example

Replace the placeholder values before running these commands.

#### Bash

```bash
OWNER="$(gh api user --jq .login)"
TEMPLATE_OWNER="techie2000"
TEMPLATE_REPO="work-template-docs"
REPO="replace-with-your-new-repo-name"

# Creates a new repository from the template.
gh repo create "$OWNER/$REPO" --private --template "$TEMPLATE_OWNER/$TEMPLATE_REPO"

# Then enables automatic branch deletion on merge for that new repository.
gh api --method PATCH "/repos/$OWNER/$REPO" -f delete_branch_on_merge=true
```

#### PowerShell

```powershell
$owner = gh api user --jq '.login'
$templateOwner = 'techie2000'
$templateRepo = 'work-template-docs'
$repo = 'replace-with-your-new-repo-name'

# Creates a new repository from the template.
gh repo create "$owner/$repo" --private --template "$templateOwner/$templateRepo"

# Then enables automatic branch deletion on merge for that new repository.
gh api --method PATCH "/repos/$owner/$repo" -f delete_branch_on_merge=true
```

### Existing repository created in the GitHub web UI

If you already created the repository in the browser with **Use this template**,
run only the PATCH command against the repository that already exists.

#### Bash

```bash
OWNER="$(gh api user --jq .login)"
REPO="replace-with-your-existing-repo-name"

gh api --method PATCH "/repos/$OWNER/$REPO" -f delete_branch_on_merge=true
```

#### PowerShell

```powershell
$owner = gh api user --jq '.login'
$repo = 'replace-with-your-existing-repo-name'

gh api --method PATCH "/repos/$owner/$repo" -f delete_branch_on_merge=true
```

Temporary Files and Diagnostic Output
Transient logs, timing files, build output, and other diagnostic artifacts
should be written under .tmp/ at the repository root rather than the repo
root itself.

The template also includes .markdownlintignore with .tmp/** so temporary
markdown files created in .tmp/ do not fail repository markdown linting. This
keeps diagnostics out of normal documentation validation while still allowing
committed docs to remain fully linted.

## PowerShell Guidance

When adding or editing PowerShell in repositories created from this template:

- Use only approved PowerShell verbs for function names.
- Treat `PSScriptAnalyzer` rule `PSUseApprovedVerbs` as a required check
 for new or edited PowerShell code.
- Review `.github/instructions/powershell-approved-verbs.instructions.md`
 for the repository instruction used by Copilot.
- The repository includes `scripts/PSScriptAnalyzerSettings.psd1` and
 `.github/workflows/powershell-lint.yml` to validate PowerShell scripts in
 GitHub Actions.

## Repository Customization Checklist

1. Replace this README with project-specific context.
2. Add or update files in [docs/vendor/](docs/vendor/) and [docs/internal/](docs/internal/).
3. Add screenshots/diagrams under [images/](images/).
4. Update [.vscode/extensions.json](.vscode/extensions.json) recommendations if needed.
5. Review the bootstrap-generated project cSpell word list in
   [.vscode/](.vscode/) and add any extra domain terms it cannot infer.
6. If you add additional word lists, register each under `cSpell.customDictionaries` in [.vscode/settings.json](.vscode/settings.json).
7. If you add PowerShell automation, keep
 `scripts/PSScriptAnalyzerSettings.psd1` aligned with your linting policy and
 ensure the GitHub Actions workflow still covers your PowerShell files.
