#!/bin/bash
{{ if eq .chezmoi.os "darwin" -}}
if command -v rtk >/dev/null 2>&1; then
	echo "Initializing rtk for opencode..."
	rtk init -g opencode
fi
{{ end -}}
