#!/bin/bash
# Uninstall claude-commands

echo "Uninstalling Claude Commands..."
COMMANDS_PATH="$HOME/.claude/commands"

if [ -d "$COMMANDS_PATH" ]; then
    rm -rf "$COMMANDS_PATH"
    echo "✅ Commands removed from user directory"
else
    echo "❌ No commands found to remove"
fi

# Remove this uninstall script
rm -f "$0"
