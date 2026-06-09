#!/usr/bin/env sh
set -eu

if [ ! -f "package.json" ]; then
  echo "No package.json found; skipping package bootstrap."
  exit 0
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm not found; skipping package bootstrap."
  exit 0
fi

current_name=$(npm pkg get name 2>/dev/null | tr -d '"' || true)
repo_name=$(basename "$PWD")

sanitized=$(printf '%s' "$repo_name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9._-]+/-/g; s/-+/-/g; s/^[-._]+//; s/[-._]+$//')
if [ -z "$sanitized" ]; then
  sanitized="project-docs"
fi

should_replace=false
if [ -z "$current_name" ] || [ "$current_name" = "template-docs" ] || [ "$current_name" = "work-template-docs" ]; then
  should_replace=true
fi

if [ "$should_replace" = "true" ] && [ "$current_name" != "$sanitized" ]; then
  npm pkg set "name=$sanitized" >/dev/null
  echo "Updated package.json name: $current_name -> $sanitized"
else
  echo "Keeping package.json name: $current_name"
fi

npm pkg set "private=true" --json >/dev/null
