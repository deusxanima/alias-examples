#!/bin/bash

# GitHub repository details
REPO_URL="https://github.com/deusxanima/alias-examples.git"
CLONE_DIR="${HOME}/.alias_repo"

# Temporary alias file
TEMP_ALIAS_FILE="${HOME}/.temp_aliases"

# Function to clear previous aliases
clear_aliases() {
    if [ -f "$TEMP_ALIAS_FILE" ]; then
        unalias -a
        rm -f "$TEMP_ALIAS_FILE"
    fi
}

# Function to update alias repo
update_repo() {
    if [ -d "$CLONE_DIR" ]; then
        git -C "$CLONE_DIR" pull
    else
        git clone "$REPO_URL" "$CLONE_DIR"
    fi
}

# Main logic
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <local|remote>"
    exit 1
fi

# Clear old aliases
clear_aliases

# Update the alias repo
update_repo

# Determine which alias file to source
case "$1" in
    local)
        ALIAS_FILE="$CLONE_DIR/load_alias_local.sh"
        ;;
    remote)
        ALIAS_FILE="$CLONE_DIR/load_alias_remote.sh"
        ;;
    *)
        echo "Invalid argument: $1. Use 'local' or 'remote'."
        exit 1
        ;;
esac

# Source the alias file if it exists
if [ -f "$ALIAS_FILE" ]; then
    cp "$ALIAS_FILE" "$TEMP_ALIAS_FILE"
    source "$TEMP_ALIAS_FILE"
    echo "Aliases loaded from $ALIAS_FILE."
else
    echo "Alias file not found: $ALIAS_FILE"
    exit 1
fi
