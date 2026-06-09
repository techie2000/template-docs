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

current_name=$(npm pkg get name 2>/dev/null | tr -d '"[:space:]' || true)
if [ "$current_name" = "undefined" ] || [ "$current_name" = "null" ]; then
  current_name=""
fi

current_private=$(npm pkg get private 2>/dev/null | tr -d '"[:space:]' || true)
if [ "$current_private" = "undefined" ] || [ "$current_private" = "null" ]; then
  current_private=""
fi

current_description=$(npm pkg get description 2>/dev/null | tr -d '"' || true)
if [ "$current_description" = "undefined" ] || [ "$current_description" = "null" ]; then
  current_description=""
fi

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

template_description="Reusable template for documentation-first projects."
default_description="Documentation for $repo_name."
should_replace_description=false
if [ "$should_replace" = "true" ] || [ -z "$current_description" ] || [ "$current_description" = "$template_description" ]; then
  should_replace_description=true
fi

if [ "$should_replace_description" = "true" ] && [ "$current_description" != "$default_description" ]; then
  npm pkg set "description=$default_description" >/dev/null
  echo "Updated package.json description: $current_description -> $default_description"
else
  echo "Keeping package.json description: $current_description"
fi

if [ "$should_replace" = "true" ] || [ -z "$current_private" ]; then
  npm pkg set "private=true" --json >/dev/null
  echo "Ensured package.json private=true"
else
  echo "Keeping package.json private: $current_private"
fi

settings_path=".vscode/settings.json"
if [ ! -f "$settings_path" ]; then
  echo "No $settings_path found; skipping cSpell bootstrap."
  exit 0
fi

dict_name="${sanitized}-words"
dict_file=".vscode/${dict_name}.txt"
template_dict_file=".vscode/generic-project-words.txt"

node - "$repo_name" "$sanitized" "$settings_path" "$dict_name" "$dict_file" "$template_dict_file" <<'NODE'
const fs = require("fs");
const path = require("path");

const [repoName, sanitizedName, settingsPath, dictionaryName, dictionaryFilePath, templateDictionaryPath] = process.argv.slice(2);

function splitWords(value) {
  return value
    .split(/[^A-Za-z0-9]+/)
    .map((word) => word.trim().toLowerCase())
    .filter((word) => word.length > 0);
}

function readWordFile(filePath) {
  if (!fs.existsSync(filePath)) {
    return [];
  }

  return fs
    .readFileSync(filePath, "utf8")
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line.length > 0);
}

function sortNode(node) {
  if (Array.isArray(node)) {
    return node.map((item) => sortNode(item));
  }

  if (node && typeof node === "object") {
    const sorted = {};
    for (const key of Object.keys(node).sort((left, right) => left.localeCompare(right))) {
      sorted[key] = sortNode(node[key]);
    }
    return sorted;
  }

  return node;
}

const seededWords = new Set();
for (const token of splitWords(repoName)) {
  seededWords.add(token);
}
for (const token of splitWords(sanitizedName)) {
  seededWords.add(token);
}
seededWords.add(sanitizedName.toLowerCase());

for (const word of readWordFile(templateDictionaryPath)) {
  seededWords.add(word);
}
for (const word of readWordFile(dictionaryFilePath)) {
  seededWords.add(word);
}

const sortedWords = [...seededWords].sort((left, right) => left.localeCompare(right));
fs.mkdirSync(path.dirname(dictionaryFilePath), { recursive: true });
fs.writeFileSync(dictionaryFilePath, `${sortedWords.join("\n")}\n`, "utf8");

const settings = JSON.parse(fs.readFileSync(settingsPath, "utf8"));
if (!settings.cSpell || typeof settings.cSpell !== "object" || Array.isArray(settings.cSpell)) {
  settings.cSpell = {};
}
if (
  !settings.cSpell.customDictionaries ||
  typeof settings.cSpell.customDictionaries !== "object" ||
  Array.isArray(settings.cSpell.customDictionaries)
) {
  settings.cSpell.customDictionaries = {};
}

const customDictionaries = settings.cSpell.customDictionaries;
const genericDictionaryName = "generic-project-words";
if (
  customDictionaries[genericDictionaryName] &&
  customDictionaries[genericDictionaryName].path === "${workspaceFolder}/.vscode/generic-project-words.txt"
) {
  delete customDictionaries[genericDictionaryName];
}

customDictionaries[dictionaryName] = {
  addWords: true,
  description: "Project-specific accepted words",
  name: dictionaryName,
  path: `\${workspaceFolder}/.vscode/${path.basename(dictionaryFilePath)}`,
  scope: "workspace",
};

const formattedSettings = `${JSON.stringify(sortNode(settings), null, 2)}\n`;
fs.writeFileSync(settingsPath, formattedSettings, "utf8");

console.log(`Ensured cSpell word list: ${dictionaryFilePath}`);
console.log(`Ensured cSpell dictionary registration: ${dictionaryName}`);
NODE
