.RECIPEPREFIX := >

.PHONY: install-hooks settings-sort lint-docs lint-docs-fix

ifeq ($(OS),Windows_NT)
install-hooks:
>pwsh ./scripts/install-hooks.ps1

settings-sort:
>pwsh ./scripts/settings-sort.ps1

lint-docs:
>pwsh ./scripts/lint-docs.ps1

lint-docs-fix:
>pwsh ./scripts/lint-docs.ps1 -Fix
else
install-hooks:
>./scripts/install-hooks.sh

settings-sort:
>./scripts/settings-sort.sh

lint-docs:
>./scripts/lint-docs.sh

lint-docs-fix:
>./scripts/lint-docs.sh --fix
endif
