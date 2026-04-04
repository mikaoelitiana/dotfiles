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
3. Prompt for configuration values (email address for git config)
4. Run pre-install scripts (installs Nix, and Homebrew on macOS)
5. Apply all dotfiles to your home directory
6. Run post-apply scripts (installs mise tools)

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
