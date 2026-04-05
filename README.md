# Chezmoi Dotfiles

Personal development environment configuration managed by [chezmoi](https://www.chezmoi.io/).

Includes:
- Shell configurations (bash, zsh) with mise
- Git configuration and templates
- Neovim editor setup
- Tool configurations (lazygit, k9s, rectangle)
- Installation scripts for development tools

## Prerequisites

- macOS or Linux (Ubuntu, Debian, Fedora, Arch)
- `curl` available in your shell
- `sudo` access (for Linux package installation)

## Installation

### 1. Install chezmoi and apply dotfiles

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mikaoelitiana
```

This command will:
1. Install chezmoi if not already present
2. Clone this repository
3. Prompt for configuration values (email address for git config)
4. Run pre-install scripts (installs Homebrew on macOS, or updates package managers on Linux)
5. Apply all dotfiles to your home directory
6. Install packages (via Homebrew on macOS, native package managers on Linux)
7. Run post-apply scripts (installs mise tools)

## Updating

To pull the latest changes and re-apply:

```sh
chezmoi update
```

## Manual Steps

After the initial setup, you may want to:

1. Set your default shell to fish:
   ```sh
   chsh -s $(which fish)
   ```

## Platform-Specific Behavior

This configuration automatically adapts to your operating system:

- **macOS**: Uses Homebrew for packages, stores app preferences in `~/Library`
- **Linux**: Uses native package managers (apt/dnf/pacman), stores configs in `~/.config`

Cross-platform configs (lazygit, k9s, neovim, fish) are stored in `~/.config` and work on both systems.

## Customization

The git configuration is managed through `dot_gitconfig.tmpl` using [chezmoi's templating system](https://www.chezmoi.io/user-guide/templating/).

To view all current template data:
```sh
chezmoi data
```

To update your git email address after installation, edit the chezmoi configuration:
```sh
chezmoi edit-config
```

Then update the `email` value in the `[data]` section and apply the changes:
```sh
chezmoi apply
```

## Managing Packages

Packages are defined in `.chezmoidata/packages.yaml`:
- `packages.darwin.brews`: Homebrew packages for macOS
- `packages.darwin.casks`: Homebrew casks (macOS apps)
- `packages.linux.apt`: APT packages for Debian/Ubuntu

### macOS-Specific Apps (Casks)

Some macOS apps don't have direct Linux equivalents and need to be installed separately:
- **Rectangle** (window manager) → Linux: `i3`, `sway`, or built-in window manager
- **Ghostty** (terminal) → May work on Linux if built from source
- **Emdash** → macOS-only
- **DBeaver** → Available for Linux via `.deb` or Flatpak
- **Google Chrome** → Available for Linux via `.deb` download

### Tools Installed via Script on Linux

The following tools are automatically installed via `run_onchange_linux-install-packages.sh.tmpl`:
- gh (GitHub CLI)
- lazygit
- mise
- k9s
- neovim-remote
- diff-so-fancy
- exercism
- dolt

**Note:** `opencode` and `beads` are not automatically installed on Linux. You'll need to install them manually if needed.
