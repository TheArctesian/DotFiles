#!/usr/bin/env bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This installer supports macOS only.\n' >&2
  exit 1
fi

if command -v nix >/dev/null 2>&1; then
  printf 'Nix is already installed: %s\n' "$(nix --version)"
  exit 0
fi

if [[ -x /nix/var/nix/profiles/default/bin/nix ]]; then
  printf 'Nix is installed but is not loaded in this shell. Start a new shell and try again.\n'
  exit 0
fi

installer="$(mktemp -t nix-install)"
trap 'rm -f "$installer"' EXIT

printf 'Downloading the official Nix installer from nixos.org...\n'
curl --proto '=https' --tlsv1.2 --fail --location \
  --output "$installer" https://nixos.org/nix/install

printf 'Starting the Nix multi-user installer. It may request administrator access.\n'
sh "$installer"

printf '\nNix installed. Start a new shell before using it.\n'
