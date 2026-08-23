#!/usr/bin/env bash

set -euo pipefail

dry_run=false

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run]

Link the repository's .config files into the current user's XDG config home.
Existing managed files are backed up before they are replaced.
Directories targeted by the fish `cd` shortcuts (wrk, per, ...) are created
if they are missing.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --dry-run)
      dry_run=true
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$arg" >&2
      usage >&2
      exit 2
      ;;
  esac
done

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_dir="$repo_dir/.config"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
timestamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup}/$timestamp"

if [[ ! -d "$source_dir" ]]; then
  printf 'Missing config directory: %s\n' "$source_dir" >&2
  exit 1
fi

link_file() {
  local source="$1"
  local relative="${source#"$source_dir"/}"
  local destination="$config_home/$relative"
  local backup="$backup_dir/$relative"

  if [[ "$source" == "$destination" ]]; then
    return
  fi

  if [[ -L "$destination" ]] && [[ "$(readlink "$destination")" == "$source" ]]; then
    printf 'ok      %s\n' "$destination"
    return
  fi

  if [[ -e "$destination" || -L "$destination" ]]; then
    printf 'backup  %s -> %s\n' "$destination" "$backup"
    if [[ "$dry_run" == false ]]; then
      mkdir -p "$(dirname "$backup")"
      mv "$destination" "$backup"
    fi
  fi

  printf 'link    %s -> %s\n' "$destination" "$source"
  if [[ "$dry_run" == false ]]; then
    mkdir -p "$(dirname "$destination")"
    ln -s "$source" "$destination"
  fi
}

create_shortcut_dirs() {
  local fish_config="$source_dir/fish/config.fish"

  if [[ ! -f "$fish_config" ]]; then
    return
  fi

  local relative destination
  # Pull the targets out of aliases such as: alias wrk="cd $HOME/Scripts/Work"
  while IFS= read -r relative; do
    destination="$HOME/$relative"

    if [[ -d "$destination" ]]; then
      printf 'ok      %s\n' "$destination"
      continue
    fi

    printf 'mkdir   %s\n' "$destination"
    if [[ "$dry_run" == false ]]; then
      mkdir -p "$destination"
    fi
  done < <(sed -n 's|^alias [A-Za-z0-9_]*="cd \$HOME/\(.*\)"$|\1|p' "$fish_config" | sort -u)
}

while IFS= read -r -d '' source; do
  link_file "$source"
done < <(find "$source_dir" -type f ! -name '.DS_Store' -print0)

create_shortcut_dirs

if [[ "$dry_run" == true ]]; then
  printf '\nDry run only; no files were changed.\n'
else
  printf '\nDotfiles installed.\n'
fi
