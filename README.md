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
- A [GitHub personal access token](https://github.com/settings/tokens) stored in your system keychain (see [Manual Steps](#manual-steps) below)

## Installation

### 1. Install chezmoi and apply dotfiles

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mikaoelitiana
```

This single command will bootstrap your entire environment:

1. **Install chezmoi** to `~/.local/bin/` (via the official `get.chezmoi.io` installer)
2. **Clone** this dotfiles repository
3. **Prompt** for your email address and preferred ACP provider (stored in chezmoi config for git, jj, and neovim templates)
4. **Install Homebrew** on macOS if not already present (on Linux, updates the system package manager)
5. **Apply** all dotfiles to your home directory
6. **Install packages** (via Homebrew on macOS, native package managers on Linux)
7. **Install mise tools** (runtime versions for Node.js, Python, etc.)

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

### 1. Store your GitHub token in the system keychain

Some templates use a GitHub PAT from the system keychain via chezmoi's
`keyring` function. Store yours before running `chezmoi apply`:

```sh
gh auth token | security add-generic-password -a "$(gh api user --jq .login)" -s github -w -U
```

This copies your existing `gh` auth token into the macOS Keychain. Verify:

```sh
security find-generic-password -a "$(gh api user --jq .login)" -s github -w
```

### 2. Set your default shell to fish

```sh
# Add fish to the list of allowed shells
command -v fish | sudo tee -a /etc/shells
# Set fish as your default login shell
chsh -s "$(command -v fish)"
```

## Platform-Specific Behavior

This configuration automatically adapts to your operating system:

- **macOS**: Uses Homebrew for packages, stores app preferences in `~/Library`
- **Linux**: Uses native package managers (apt/dnf/pacman), stores configs in `~/.config`

Cross-platform configs (lazygit, k9s, neovim, fish) are stored in `~/.config` and work on both systems.

## Customization

The git configuration is managed through `dot_gitconfig.tmpl` using [chezmoi's templating system](https://www.chezmoi.io/user-guide/templating/).

### Chezmoi Data Reference

The following keys can be set under `[data]` in your chezmoi config (`chezmoi edit-config`) to customize behaviour:

| Key | Description | Default |
|-----|-------------|---------|
| `data.neovim.agenticProvider` | ACP provider used by [agentic.nvim](https://github.com/carlos-algms/agentic.nvim) | `opencode-acp` |
| `keyring("github", "<user>")` | GitHub PAT used by LM Studio MCP and other integrations. Stored in system keychain via `security add-generic-password`. | — |

Built-in provider values: `claude-agent-acp`, `gemini-acp`, `codex-acp`, `opencode-acp`, `cursor-acp`, `copilot-acp`, `auggie-acp`, `mistral-vibe-acp`, `cline-acp`, `goose-acp`, `kiro-acp`, `pi-acp`.

Example `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
  email = "you@example.com"

[data.neovim]
  agenticProvider = "claude-agent-acp"
```

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
