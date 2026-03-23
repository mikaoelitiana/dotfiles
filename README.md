# Chezmoi Dotfiles

Personal development environment configuration managed by [chezmoi](https://www.chezmoi.io/).

Includes:
- Shell configurations (bash, zsh) with mise
- Git configuration and templates
- Neovim editor setup
- Tool configurations (lazygit, k9s, rectangle)
- Installation scripts for development tools

## Prerequisites

- macOS (primary platform) or Linux
- `curl` available in your shell

## Installation

### 1. Install chezmoi and apply dotfiles

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mikaoelitiana
```

This command will:
1. Install chezmoi if not already present
2. Clone this repository
3. Run pre-install scripts (installs Nix, and Homebrew on macOS)
4. Apply all dotfiles to your home directory
5. Run post-apply scripts (installs mise tools)

### 2. Install packages

On macOS, install all Homebrew packages and casks:

```sh
chezmoi apply
```

The `run_onchange_darwin-install-packages.sh.tmpl` script will automatically install the following via Homebrew:

**CLI tools:** git, mise, gawk, gpg, colima, fish, lua-language-server, neovim (HEAD), neovim-remote, lazygit, gh, k9s, ripgrep, diff-so-fancy, opencode, exercism, beads, tmux, dolt

**GUI apps (casks):** Google Chrome, DBeaver Community, Rectangle, Ghostty, Emdash, Claude Code

## What Gets Installed Automatically

| Script | Trigger | Action |
|--------|---------|--------|
| `run_once_before_install-base-packages.sh.tmpl` | Once, before apply | Installs Nix; installs Homebrew on macOS |
| `run_onchange_darwin-install-packages.sh.tmpl` | On change, macOS only | Installs/updates Homebrew packages and casks |
| `run_after_apply.sh` | After every apply | Runs `mise install` to install all mise-managed tools |

## Updating

To pull the latest changes and re-apply:

```sh
chezmoi update
```

## Manual Steps

After the initial setup, you may want to:

1. Configure Git identity (if not set via chezmoi template data):
   ```sh
   git config --global user.name "Your Name"
   git config --global user.email "you@example.com"
   ```

2. Set your default shell to fish:
   ```sh
   chsh -s $(which fish)
   ```
