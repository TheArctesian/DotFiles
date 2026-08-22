# macOS dotfiles

This repository manages the portable parts of the current macOS setup. Files
under `.config/` map directly to the same relative path under
`${XDG_CONFIG_HOME:-~/.config}`.

## Managed configuration

- btop
- Fish and Oh My Fish
- GitHub CLI
- Ghostty
- Git global ignores
- Neovim
- Nix
- OpenCode commands, plugins, skills, and settings
- Zed
- Zellij
- Zotero MCP

Credentials, generated state, caches, downloaded dependencies, local Claude
settings, and machine identifiers are intentionally not tracked. In
particular, this excludes `gh/hosts.yml`, `fish/fish_variables`, OpenCode env
and tunnel files, Photon credentials, Raycast extensions, and app databases.

## Install

Install Nix using the official macOS multi-user installer:

```sh
./install-nix.sh
```

Start a new shell after the Nix installer finishes. The managed Nix config
enables `nix-command` and flakes.

Install the curated command-line tools and applications:

```sh
brew bundle
```

Preview the links that will be created:

```sh
./install.sh --dry-run
```

Apply the configuration:

```sh
./install.sh
```

The installer links individual files, not entire directories. Existing files
at managed paths are moved to `~/.dotfiles-backup/<timestamp>/` first, while
unmanaged local files remain untouched.

Restart OpenCode after installing because it reads global configuration only
at startup.

## Updating

Once installed, editing a managed file in either this repository or
`~/.config` edits the same file through the symlink. Before adding a new live
config, check it for credentials and generated state, then place only its
portable files under `.config/<application>/`.

## Historical files

The previous Linux, distro, desktop-environment, and macOS experiments are
preserved under `legacy/`. They are not installed or maintained by the current
bootstrap process.
