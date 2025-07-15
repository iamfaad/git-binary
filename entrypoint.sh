#!/bin/sh
set -e

# Check required environment variables
if [ -z "$REPO_DIRECTORY" ]; then
    echo "❌ Missing REPO_DIRECTORY environment variable"
    exit 1
fi

if [ -z "$REPO_BRANCH" ]; then
    echo "❌ Missing REPO_BRANCH environment variable"
    exit 2
fi

# Ensure SSH private key exists
if [ ! -f /root/.ssh/id_rsa ]; then
  echo "❌ SSH private key not found at /root/.ssh/id_rsa"
  exit 3
fi

# Check if the target directory is a Git repo
if [ ! -d "$REPO_DIRECTORY/.git" ]; then
  echo "❌ No Git repository found in $REPO_DIRECTORY"
  exit 4
fi

# Trust GitHub to avoid host verification issues
ssh-keyscan github.com >> /root/.ssh/known_hosts
git config --global --add safe.directory "$REPO_DIRECTORY"

cd "$REPO_DIRECTORY"
echo "🔄 Checking out branch $REPO_BRANCH..."
git checkout "$REPO_BRANCH"

# Determine commit
if [ -n "$COMMIT_HASH" ]; then
  echo "📌 Using provided commit: $COMMIT_HASH"
else
  if [ -z "$COMMIT_AFTER_DATE" ] || [ -z "$COMMIT_BEFORE_DATE" ]; then
      echo "❌ Either COMMIT or COMMIT_{AFTER,BEFORE}_DATE must be set"
      exit 5
  fi

  echo "🔍 Searching for commit between $COMMIT_AFTER_DATE and $COMMIT_BEFORE_DATE..."
  export COMMIT_HASH=$(git log origin/$REPO_BRANCH --after="$COMMIT_AFTER_DATE" --before="$COMMIT_BEFORE_DATE" | grep -i commit | head -1 | awk '{print $2}')

  if [ -z "$COMMIT_HASH" ]; then
    echo "❌ No commit found in the given date range"
    exit 6
  fi
fi

# Perform the reset
echo "🔁 Resetting to commit $COMMIT_HASH..."
git reset --hard "$COMMIT_HASH"

echo "✅ Git reset completed successfully."
