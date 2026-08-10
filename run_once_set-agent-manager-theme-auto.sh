#!/bin/bash
# Set theme_auto to on in agent-manager's SQLite database

set -euo pipefail

DB_PATH="${HOME}/Library/Application Support/agent-manager/state.db"

# Check if the database exists
if [[ ! -f "$DB_PATH" ]]; then
    echo "agent-manager database not found at $DB_PATH"
    exit 0
fi

# Check if sqlite3 is available
if ! command -v sqlite3 &> /dev/null; then
    echo "sqlite3 not found, cannot set theme_auto"
    exit 0
fi

# Set theme_auto to on
sqlite3 "$DB_PATH" "INSERT OR REPLACE INTO settings (key, value) VALUES ('theme_auto', 'on');"

echo "Set theme_auto to on in agent-manager"
