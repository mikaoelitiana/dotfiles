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
- `bash` available at `/bin/bash`

## Installation

### 1. Install chezmoi and apply dotfiles

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mikaoelitiana
```

This single command will bootstrap your entire environment:

1. **Install chezmoi** to `~/.local/bin/` (via the official `get.chezmoi.io` installer)
2. **Clone** this dotfiles repository
3. **Prompt** for configuration values (email address for git config)
4. **Install Homebrew** on macOS if not already present (on Linux, updates the system package manager)
5. **Install Bitwarden CLI** (via Homebrew on macOS, direct download on Linux)
6. **Apply** all dotfiles to your home directory
7. **Install packages** (via Homebrew on macOS, native package managers on Linux)
8. **Install mise tools** (runtime versions for Node.js, Python, etc.)

> **Note:** On Apple Silicon Macs, Homebrew installs to `/opt/homebrew/`. The setup scripts
> automatically configure the PATH for this. After installation completes, open a new terminal
> session to ensure all PATH changes take effect.
>
> chezmoi is also included as a Homebrew formula, so after the initial bootstrap it will be
> managed and updated via Homebrew alongside all other packages.

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
