#!/bin/sh
# Usage: ./scripts/shell/p0_push_git.sh "Your commit message"

set -e

COMMIT_MSG="$1"

git checkout "${BRANCH:-develop}"

if [ -n "$(git status --porcelain)" ]; then
    echo "Changes detected. Committing."
    git add .
    git commit -am "$COMMIT_MSG"
    git remote set-url origin "https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/dahphi/Philipps_Spielwiese.git"
    git push
else
    echo "No changes detected. Skipping commit."
fi

git status
