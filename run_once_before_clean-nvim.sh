#!/bin/sh
# Clean stale Neovim data/state/cache before chezmoi applies the nvim config.
# This ensures a pristine LazyVim setup without conflicts from prior installs.
# Runs once, before apply.

# Idempotency guard: skip if LazyVim is already bootstrapped (lazy-lock.json
# is created by lazy.nvim after the first successful plugin sync).
if [ -f "${HOME}/.config/nvim/lazy-lock.json" ]; then
	exit 0
fi

echo "Cleaning stale Neovim data/state/cache..."
rm -rf "${HOME}/.local/share/nvim"
rm -rf "${HOME}/.local/state/nvim"
rm -rf "${HOME}/.cache/nvim"
echo "Neovim state cleaned."
