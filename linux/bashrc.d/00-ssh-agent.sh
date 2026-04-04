#!/bin/bash

# --- Auto SSH Agent ---
# This script ensures an ssh-agent is running and the GitHub key is loaded.

SSH_KEY="$HOME/.ssh/fedora_laptop_github"

if [ -f "$SSH_KEY" ]; then
    # Check if agent is already running
    if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" > /dev/null
    fi

    # Add the key if it's not already in the agent
    ssh-add -l | grep -q "$SSH_KEY" || ssh-add "$SSH_KEY" 2>/dev/null
fi
