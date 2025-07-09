#!/bin/sh
set -e

# Directory where the Git repo exists (default to /odoo-addon if not set)
if [ -z "$REPO_DIRECTORY" ]; then
    echo "❌ Missing REPO_DIRECTORY environment variable"
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

cd "$REPO_DIRECTORY"
echo "🔄 Running git pull in $REPO_DIRECTORY..."
git pull


echo "✅ git pull completed successfully."
