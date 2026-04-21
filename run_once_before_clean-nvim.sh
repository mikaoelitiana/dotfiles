#!/bin/sh
# Clean stale Neovim data/state/cache before chezmoi applies the nvim config.
# This ensures a pristine LazyVim setup without conflicts from prior installs.
# Runs once, before apply.

echo "Cleaning stale Neovim data/state/cache..."
rm -rf "${HOME}/.local/share/nvim"
rm -rf "${HOME}/.local/state/nvim"
rm -rf "${HOME}/.cache/nvim"
echo "Neovim state cleaned."
