#!/bin/sh
set -e

if [ -z "$GIT_REPO" ] || [ -z "$GIT_USERNAME" ] || [ -z "$GIT_TOKEN" ]; then
    echo "❌ Missing GIT_REPO, GIT_USERNAME, or GIT_TOKEN environment variable"
    exit 1
fi

# Build URL with token
AUTHED_REPO=$(echo "$GIT_REPO" | sed "s#https://#https://$GIT_USERNAME:$GIT_TOKEN@#")

echo "📦 Pulling repo from $AUTHED_REPO"
git pull "$AUTHED_REPO"

echo "✅ Git pull completed. Exiting."
