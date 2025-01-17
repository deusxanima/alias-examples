#!/bin/bash

# GitHub repository details
REPO_URL="https://github.com/deusxanima/alias-examples.git"
CLONE_DIR="${HOME}/.alias_repo"
TEMP_ALIAS_FILE="${HOME}/.temp_aliases"

# Ensure a cluster name is provided
if [ -z "$1" ]; then
    echo "Usage: tkl <cluster>"
    return 1
fi

CLUSTER="$1"

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
        git -C "$CLONE_DIR" pull --quiet
    else
        git clone "$REPO_URL" "$CLONE_DIR" --quiet
    fi
}

# Main logic
clear_aliases
update_repo

# Determine the alias file based on the cluster name
ALIAS_FILE="$CLONE_DIR/load_alias_${CLUSTER}.sh"
if [ -f "$ALIAS_FILE" ]; then
    cp "$ALIAS_FILE" "$TEMP_ALIAS_FILE"
    # Source the aliases directly into the current shell
    source "$TEMP_ALIAS_FILE"
    echo "Aliases loaded from $ALIAS_FILE."
else
    echo "Alias file not found for cluster: $CLUSTER."
    return 1
fi

# Run the tsh kube login command
echo "Logging into Teleport cluster: $CLUSTER"
tsh kube login "$CLUSTER"
