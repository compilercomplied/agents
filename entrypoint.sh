#!/bin/bash
set -e

# 1. Validate Secrets
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "Error: ANTHROPIC_API_KEY environment variable is not set."
    exit 1
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN environment variable is not set."
    exit 1
fi

if [ -z "$PULUMI_CONFIG_PASSPHRASE" ]; then
    echo "Error: PULUMI_CONFIG_PASSPHRASE environment variable is not set."
    exit 1
fi


# 2. Configure Git Credentials (HTTPS)
git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"

eval "$(mise activate bash)"

# 5. Execute Claude
exec claude "$@"
