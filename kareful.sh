#!/usr/bin/env bash
# Usage:
# source kareful.sh

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

IFS=$' '
kubectl_executable=$(which kubectl)
if [[ -z $kubectl_executable ]]; then
  echo "$kubectl_executable not found in PATH"
  exit 1
fi

prompt_confirm() {
  echo -n "Are you sure? [y/N] "
  read response
  echo
  case "$response" in
    [Yy]*) return 0 ;;
    *) return 1 ;;
  esac
}


kubectl() {
  if [[ ${DANGER_CONTEXTS[@]} =~ $($kubectl_executable config current-context) ]] && [[ ${DANGER_OPS[@]} =~ "$1" ]]; then
    if prompt_confirm; then
      $kubectl_executable "$@"
    else
      echo "Operation cancelled."
      return 1
    fi
  else
    $kubectl_executable "$@"
  fi
}
