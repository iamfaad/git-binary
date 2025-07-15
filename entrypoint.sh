#!/bin/sh
set -e

# Directory where the Git repo exists (default to /odoo-addon if not set)
if [ -z "$REPO_DIRECTORY" ]; then
    echo "❌ Missing REPO_DIRECTORY environment variable"
    exit 1
fi

if [ -z "$HASH_COMMIT" ]; then
    echo "❌ Missing COMMIT environment variable"
    exit 1
fi

if [ -z "$REPO_BRANCH" ]; then
    echo "❌ Missing REPO_BRANCH environment variable"
    exit 1
fi


# Ensure SSH private key exists
if [ ! -f /root/.ssh/id_rsa ]; then
  echo "❌ SSH private key not found at /root/.ssh/id_rsa"
  exit 1
fi


# Check if the target directory exists and is a git repo
if [ ! -d "$REPO_DIRECTORY/.git" ]; then
  echo "❌ No Git repository found in $REPO_DIRECTORY"
  exit 1
fi

# Trust GitHub to avoid host verification errors
ssh-keyscan github.com >> /root/.ssh/known_hosts

# Let Git trust this directory (due to UID mismatch in Docker)
git config --global --add safe.directory "$REPO_DIRECTORY"


cd "$REPO_DIRECTORY"
echo "🔄 choosing the branch..."
git checkout $REPO_BRANCH
echo "🔄 Running git pull in $REPO_DIRECTORY..."
git reset --hard $HASH_COMMIT


echo "✅ git pull completed successfully."
