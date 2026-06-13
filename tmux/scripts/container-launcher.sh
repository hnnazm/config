#!/usr/bin/env bash

CONTAINERS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/containers"

if ! command -v docker-compose &>/dev/null; then
  echo "Error: docker-compose is not installed." >&2
  exit 1
fi

if ! docker-compose ls &>/dev/null; then
  echo "Error: cannot reach the Docker daemon. Is colima running? (colima start)" >&2
  exit 1
fi

containers=()
while IFS= read -r compose_file; do
  dir=$(dirname "$compose_file")
  name=$(basename "$dir")
  containers+=("$name")
done < <(find "$CONTAINERS_DIR" -maxdepth 2 \( -name "compose.yaml" -o -name "compose.yml" \) 2>/dev/null | sort)

if [[ ${#containers[@]} -eq 0 ]]; then
  echo "No containers found in $CONTAINERS_DIR" >&2
  exit 1
fi

list=""
for name in "${containers[@]}"; do
  compose_file="$CONTAINERS_DIR/$name/compose.yaml"
  [[ ! -f "$compose_file" ]] && compose_file="$CONTAINERS_DIR/$name/compose.yml"
  status=$(docker-compose -f "$compose_file" ps --services --filter "status=running" 2>/dev/null | wc -l | tr -d ' ')
  if [[ "$status" -gt 0 ]]; then
    label="$name  [running]"
  else
    label="$name  [stopped]"
  fi
  list+="$label"$'\n'
done

selected=$(printf '%s' "$list" | fzf \
  --prompt="Container> " \
  --reverse \
  --preview='
    name=$(echo {} | awk "{print \$1}")
    f="'"$CONTAINERS_DIR"'/$name/compose.yaml"
    [[ ! -f "$f" ]] && f="'"$CONTAINERS_DIR"'/$name/compose.yml"
    cat "$f"
  ' \
  --preview-window=right:60%)

[[ -z "$selected" ]] && exit 0

name=$(echo "$selected" | awk '{print $1}')
compose_file="$CONTAINERS_DIR/$name/compose.yaml"
[[ ! -f "$compose_file" ]] && compose_file="$CONTAINERS_DIR/$name/compose.yml"

echo "Starting $name..."
if ! docker-compose -f "$compose_file" up -d; then
  echo "Error: Failed to start $name." >&2
  exit 1
fi

echo "$name is up."
