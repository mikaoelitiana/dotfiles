#!/bin/sh
# Bootstrap LazyVim: install plugins headlessly after chezmoi has applied the nvim config.
# This runs once after apply to ensure LazyVim is fully set up.

set -e

# Only proceed if nvim is available
if ! command -v nvim >/dev/null 2>&1; then
	echo "nvim not found, skipping LazyVim bootstrap"
	exit 0
fi

# Idempotency guard: skip if lazy.nvim is already installed and plugins are synced.
if [ -d "${HOME}/.local/share/nvim/lazy/lazy.nvim" ] && [ -f "${HOME}/.config/nvim/lazy-lock.json" ]; then
	echo "LazyVim plugins already installed, skipping bootstrap."
	exit 0
fi

echo "Bootstrapping LazyVim (headless plugin install)..."
nvim --headless "+Lazy! sync" +qa

echo "LazyVim bootstrap complete."
