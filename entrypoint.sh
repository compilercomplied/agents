#!/bin/bash
set -e

git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"

eval "$(mise activate bash)"

# Execute Claude with args
exec claude "$@"
