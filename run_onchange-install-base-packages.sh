#!/bin/sh
echo "Installing Nix..."
curl -L https://nixos.org/nix/install | sh

echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
