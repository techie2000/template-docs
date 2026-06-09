.RECIPEPREFIX := >

.PHONY: init install-hooks settings-sort bootstrap-package lint-docs lint-docs-fix

ifeq ($(OS),Windows_NT)
init: install-hooks settings-sort bootstrap-package

install-hooks:
>pwsh ./scripts/install-hooks.ps1

settings-sort:
>pwsh ./scripts/settings-sort.ps1

bootstrap-package:
>pwsh ./scripts/bootstrap-package-name.ps1

lint-docs:
>pwsh ./scripts/lint-docs.ps1

lint-docs-fix:
>pwsh ./scripts/lint-docs.ps1 -Fix
else
init: install-hooks settings-sort bootstrap-package

install-hooks:
>bash ./scripts/install-hooks.sh

settings-sort:
>bash ./scripts/settings-sort.sh

bootstrap-package:
>bash ./scripts/bootstrap-package-name.sh

lint-docs:
>bash ./scripts/lint-docs.sh

lint-docs-fix:
>bash ./scripts/lint-docs.sh --fix
endif
