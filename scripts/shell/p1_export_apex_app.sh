#!/bin/bash

DB_USER=$1
DB_PASS=$2
DB_HOST=$3
BASE_DIR=$4
APP_ID=$5
CONN="${DB_USER}/${DB_PASS}@${DB_HOST}"

if [ -z "$4" ]; then
  echo "Usage: $0 <APP_ID>"
  exit 1
fi
cd $BASE_DIR/f$APP_ID

# Comment out artifact/* and *.zip entries in .gitignore if present
if [ -f .gitignore ]; then
  tmpfile="$(mktemp)"
  sed -E \
    -e 's|^[[:space:]]*artifact/\*[[:space:]]*$|#artifact/*|' \
    -e 's|^[[:space:]]*\*\.zip[[:space:]]*$|#*.zip|' \
    .gitignore > "$tmpfile" && mv "$tmpfile" .gitignore
fi

sql "${CONN}" <<EOF
cd $BASE_DIR/f$APP_ID
project export -o apex.$APP_ID -verbose
exit;
EOF