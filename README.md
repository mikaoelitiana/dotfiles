# Chezmoi Dotfiles

Personal development environment configuration managed by [chezmoi](https://www.chezmoi.io/).

Includes:

- Shell configurations (fish, bash, zsh) with mise
- Git configuration and templates
- Neovim editor setup
- Tool configurations (lazygit, k9s, rectangle)
- AI agent configurations (Claude Code, opencode, goose, LM Studio, symbiotic, serena)
  including their MCP servers
- Installation scripts for development tools

## Prerequisites

- macOS or Linux (Ubuntu, Debian, Fedora, Arch)
- `curl` available in your shell
- `sudo` access (for Linux package installation)
- `bash` available at `/bin/bash`
- A [GitHub personal access token](https://github.com/settings/tokens) stored in your system keychain (see [Manual Steps](#manual-steps) below)
- `fish` as your login shell — MCP secrets are exported from `conf.d`, so agents
  launched outside fish will not see them (see [Secrets](#secrets))

## Installation

### 1. Install chezmoi and apply dotfiles

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mikaoelitiana
```

This single command will bootstrap your entire environment:

1. **Install chezmoi** to `~/.local/bin/` (via the official `get.chezmoi.io` installer)
2. **Clone** this dotfiles repository
3. **Prompt** for your email address, preferred ACP provider, and Dokploy server URL (stored in chezmoi config for git, jj, neovim, and MCP templates)
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
security add-generic-password -a "$(gh api user --jq .login)" -s github -U -w "$(gh auth token)"
```

This copies your existing `gh` auth token into the macOS Keychain. Verify:

```sh
security find-generic-password -a "$(gh api user --jq .login)" -s github -w
```

### 2. Store your MCP tokens in the system keychain

Both are optional — the MCP server that needs each one stays disabled until the
token exists.

```sh
# Dokploy API token (Dokploy panel -> Profile -> API keys)
security add-generic-password -U -s dokploy -a mikaoelitiana -w

# Playwright MCP browser-extension token
security add-generic-password -U -s playwright-mcp -a mikaoelitiana -w
```

Passing `-w` last makes `security` prompt for the value instead of taking it as
an argument, so the token never lands in your shell history.

The Dokploy *URL* is not a secret and is not stored in the keychain — it is
chezmoi data, prompted by `chezmoi init`. Set or change it with
`chezmoi edit-config`.

### 3. Set your default shell to fish

```sh
# Add fish to the list of allowed shells
command -v fish | sudo tee -a /etc/shells
# Set fish as your default login shell
chsh -s "$(command -v fish)"
```

## Secrets

**This repository is public. No secret may ever be committed to it**, including
inside a template — templates are committed too.

Secrets live in the macOS Keychain and reach configs through the environment:

```
Keychain --security(1)--> fish conf.d exports --> {env:VAR}  (opencode, symbiotic)
                                             --> ${VAR}      (Claude Code)
                                             --> env_keys    (goose)
```

`dot_config/fish/conf.d/mcp-secrets.fish.tmpl` does the exporting. Because the
values are read from the environment at runtime, no config file on disk contains
a token — with one exception, below.

Three things worth knowing:

- **LM Studio** has no environment substitution, so `dot_lmstudio/mcp.json.tmpl`
  renders the token into `~/.lmstudio/mcp.json` at apply time. That file holds
  plaintext; it is outside this repository.
- **Do not use chezmoi's `keyring` template function to test whether a secret
  exists.** It aborts the entire template when the item is absent, which breaks
  every `chezmoi apply`. Probe with `output "sh" "-c" "security ... || true"`
  instead, as the MCP templates do.
- The Dokploy server is gated on its secrets: with the token or URL missing it
  renders as `enabled: false` rather than failing at runtime. Other servers are
  enabled or disabled by hand.
- **Every item uses `mikaoelitiana` as its keychain account**, deliberately
  hardcoded rather than derived from `$USER`. The account field is an arbitrary
  label, not an OS user, so a fixed value keeps one lookup working on every
  machine regardless of login name. Deriving it from `$USER` would make an item
  created on one machine invisible on another whose login differs — and the
  symptom is a silently disabled server, not an error.

On Linux there is no `security` binary; the probes and the fish exporter are
guarded on `darwin`, so the affected servers simply render disabled.

Claude Code is the odd one out. Its MCP servers live in `~/.claude.json`, which
holds machine and account state and is deliberately *not* managed here, so
`run_onchange_configure-dokploy-mcp.sh.tmpl` registers the server with
`claude mcp add -s user` instead — and removes it when the token or URL is gone.

### Files seeded once, never overwritten

Two managed files use chezmoi's `create_` prefix because their applications
rewrite them at runtime, so a normal managed file would drift on every apply:

| File | Rewritten by |
|---|---|
| `~/.serena/serena_config.yml` | Serena, appending each project you open |
| `~/Library/Preferences/com.knollsoft.Rectangle.plist` | Rectangle, bumping a launch counter |

They are written on a fresh machine and left alone afterwards. To push a
deliberate change to one, edit the target directly — `chezmoi apply` will not
touch it.

## Troubleshooting

**Dokploy MCP fails with `Invalid URL`.** The agent was not launched from a fish
shell, so `DOKPLOY_URL` and `DOKPLOY_API_KEY` were never exported. Launch it
from fish (`exec fish`, then start the agent). This is not a chezmoi problem —
`chezmoi cat ~/.config/fish/conf.d/mcp-secrets.fish` will show the exports are
present.

**An MCP server is missing or shows as disabled.** Its token is not in the
keychain, or the Dokploy URL is unset. Check with:

```sh
security find-generic-password -s dokploy -a mikaoelitiana -w
chezmoi data | grep -A2 dokploy
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
| `data.email` | Email address used by the git, jj, and neovim templates | prompted |
| `data.neovim.agenticProvider` | ACP provider used by [agentic.nvim](https://github.com/carlos-algms/agentic.nvim) | `opencode-acp` |
| `data.dokploy.url` | Dokploy server URL for the Dokploy MCP server. Unset disables the server. | prompted |

Keychain items (not chezmoi data — see [Secrets](#secrets)):

| Service | Account | Used by |
|---------|---------|---------|
| `github` | your GitHub login | LM Studio MCP GitHub server, via chezmoi's `keyring` function |
| `dokploy` | `mikaoelitiana` | Dokploy MCP in Claude Code and opencode |
| `playwright-mcp` | `mikaoelitiana` | Playwright MCP in opencode, goose, symbiotic, LM Studio |

Built-in provider values: `claude-agent-acp`, `gemini-acp`, `codex-acp`, `opencode-acp`, `cursor-acp`, `copilot-acp`, `auggie-acp`, `mistral-vibe-acp`, `cline-acp`, `goose-acp`, `kiro-acp`, `pi-acp`.

Example `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
  email = "you@example.com"

[data.dokploy]
  url = "https://dokploy.example.com"

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
