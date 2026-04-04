#!/bin/bash

# --- Universal SSH Agent ---
# Ensures an ssh-agent is running and loads available identities.

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

# Find and add private keys if not already loaded
# We look for files in ~/.ssh that don't have public extensions or common metadata names
if [ -d "$HOME/.ssh" ]; then
    for key in "$HOME"/.ssh/*; do
        # Basic check: is it a file, not a public key, and not a system file?
        if [ -f "$key" ] && [[ ! "$key" == *.pub ]] && [[ ! "$key" == *known_hosts* ]] && [[ ! "$key" == *config ]] && [[ ! "$key" == *authorized_keys* ]]; then
            # Check if the key is already in the agent to avoid re-prompting/noise
            if ! ssh-add -l | grep -q "$(basename "$key")"; then
                ssh-add "$key" 2>/dev/null
            fi
        fi
    done
fi
