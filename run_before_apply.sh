#!/bin/fish

echo "Unlocking Bitwarden..."
set -gx BW_SESSION $(bw unlock --raw)
