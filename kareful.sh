#!/usr/bin/env bash
# Usage:
# alias kubectl='kareful.sh'

set -eu
IFS=$' '
# destructive operations:
DANGER_OPS=(
  "drain"
  "delete"
)

# dangerous contexts:
DANGER_CONTEXTS=(
  "staging"
  "production"
)


kubectl_executable=$(which kubectl)
if [[ -z $kubectl_executable ]]; then
  echo "$kubectl_executable not found in PATH"
  exit 1
fi

prompt_confirm() {
  read -rp "Are you sure? [y/N] " -n 1 response
  echo
  if [[ $response =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}


if [[ ${DANGER_CONTEXTS[@]} =~ $($kubectl_executable config current-context ) ]] && [[ ${DANGER_OPS[@]} =~ "$1" ]]; then
  if prompt_confirm; then
    $kubectl_executable "$@"
  else
    echo "Operation cancelled."
    exit 1
  fi
else
  $kubectl_executable "$@"
fi
