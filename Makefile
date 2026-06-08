.RECIPEPREFIX := >

.PHONY: init install-hooks settings-sort lint-docs lint-docs-fix

ifeq ($(OS),Windows_NT)
init: install-hooks settings-sort

install-hooks:
>pwsh ./scripts/install-hooks.ps1

settings-sort:
>pwsh ./scripts/settings-sort.ps1

lint-docs:
>pwsh ./scripts/lint-docs.ps1

lint-docs-fix:
>pwsh ./scripts/lint-docs.ps1 -Fix
else
init: install-hooks settings-sort

install-hooks:
>bash ./scripts/install-hooks.sh

settings-sort:
>bash ./scripts/settings-sort.sh

lint-docs:
>bash ./scripts/lint-docs.sh

lint-docs-fix:
>bash ./scripts/lint-docs.sh --fix
endif
