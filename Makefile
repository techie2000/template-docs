.RECIPEPREFIX := >

.PHONY: init install-hooks settings-sort bootstrap-package settings-profile-generic settings-profile-opinionated settings-profile-check-generic settings-profile-check-opinionated settings-distribute lint-docs lint-docs-fix

ifeq ($(OS),Windows_NT)
init: install-hooks settings-sort bootstrap-package

install-hooks:
>pwsh ./scripts/install-hooks.ps1

settings-sort:
>pwsh ./scripts/settings-sort.ps1

bootstrap-package:
>pwsh ./scripts/bootstrap-package-name.ps1

settings-profile-generic:
>pwsh ./scripts/settings-profile.ps1 -Action apply -Profile generic

settings-profile-opinionated:
>pwsh ./scripts/settings-profile.ps1 -Action apply -Profile opinionated

settings-profile-check-generic:
>pwsh ./scripts/settings-profile.ps1 -Action check -Profile generic

settings-profile-check-opinionated:
>pwsh ./scripts/settings-profile.ps1 -Action check -Profile opinionated

settings-distribute:
>pwsh ./scripts/settings-profile.ps1 -Action distribute -Profile generic

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

settings-profile-generic:
>bash ./scripts/settings-profile.sh -Action apply -Profile generic

settings-profile-opinionated:
>bash ./scripts/settings-profile.sh -Action apply -Profile opinionated

settings-profile-check-generic:
>bash ./scripts/settings-profile.sh -Action check -Profile generic

settings-profile-check-opinionated:
>bash ./scripts/settings-profile.sh -Action check -Profile opinionated

settings-distribute:
>bash ./scripts/settings-profile.sh -Action distribute -Profile generic

lint-docs:
>bash ./scripts/lint-docs.sh

lint-docs-fix:
>bash ./scripts/lint-docs.sh --fix
endif
