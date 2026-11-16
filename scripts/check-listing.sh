#!/bin/bash
set -euo pipefail

# Checks listing.json, the category and SF Symbol StableBar's Store shows for each widget package.
# build-index.sh copies them into each package's index entry.

file=listing.json
categories='["apps", "system", "time", "developer", "utilities", "custom"]'
problems=()

jq empty "$file" || { echo "$file isn't valid JSON" >&2; exit 1; }

while IFS= read -r problem; do
  problems+=("$problem")
done < <(jq -r --argjson categories "$categories" '
  if type != "object" then "must map package IDs to their category and symbol"
  else
    to_entries[] | .key as $id | .value |
    if type != "object" then "\($id) must be an object"
    else
      (keys - ["category", "symbol"] | .[] | "\($id) has an unknown key \"\(.)\""),
      (if [.category] | inside($categories) then empty
        else "\($id): \"category\" must be one of \($categories | join(", "))" end),
      (if .symbol | type == "string" and test("^[a-z0-9]+([.][a-z0-9]+)*$") then empty
        else "\($id): \"symbol\" must name an SF Symbol, such as cloud.sun" end)
    end
  end' "$file")

for dir in packages/*/; do
  id=$(basename "$dir")
  listed=$(jq --arg id "$id" 'has($id)' "$file")
  if [[ $(jq -r '.kind // "widgets"' "$dir/package.json") == theme ]]; then
    [[ $listed == false ]] || problems+=("$id is a theme; the Store lists themes on their own")
  elif [[ $listed == false ]]; then
    problems+=("$id needs a category and a symbol")
  fi
done
while IFS= read -r id; do
  [[ -f packages/$id/package.json ]] || problems+=("$id isn't a package in packages/")
done < <(jq -r 'keys[]' "$file")

if (( ${#problems[@]} )); then
  for problem in "${problems[@]}"; do
    echo "$file: $problem" >&2
  done
  exit 1
fi
