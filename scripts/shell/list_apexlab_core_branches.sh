#!/bin/bash
# List all remote branches of mis-apexlab-core with error handling and verbose output

set -e

echo "Running on host: $(hostname)"
echo "Git version: $(git --version)"
echo "Fetching branches from remote..."

REMOTE_URL="https://bitbucket.netcologne.intern/scm/mis/mis-apexlab-core.git"

# Try to resolve DNS first
if ! host bitbucket.netcologne.intern > /dev/null 2>&1; then
  echo "ERROR: DNS lookup failed for bitbucket.netcologne.intern"
  exit 3
fi

# Test connectivity to the remote (port 443)
if ! nc -zv bitbucket.netcologne.intern 443 > /dev/null 2>&1; then
  echo "ERROR: Cannot connect to bitbucket.netcologne.intern on port 443"
  exit 4
fi

# Test git ls-remote
if ! git ls-remote --heads "$REMOTE_URL" > /tmp/ls-remote-output.txt 2>&1; then
  echo "ERROR: Unable to reach $REMOTE_URL or permission denied."
  cat /tmp/ls-remote-output.txt
  exit 2
fi

echo "Raw git ls-remote output:"
cat /tmp/ls-remote-output.txt

echo "Parsed branch names:"
awk '{print $2}' /tmp/ls-remote-output.txt | sed 's|refs/heads/||'
