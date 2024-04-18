#!/bin/sh
if ! command -v nix &> /dev/null
then
echo "Installing Nix..."
curl -L https://nixos.org/nix/install | sh
fi

if ! command -v brew &> /dev/null
then
echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
