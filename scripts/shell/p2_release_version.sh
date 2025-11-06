#!/bin/bash

DB_USER=$1
DB_PASS=$2
DB_HOST=$3
CONN="${DB_USER}/${DB_PASS}@${DB_HOST}"

if [ -z "$4" ]; then
  echo "Usage: $0 <APP_ID>"
  exit 1
fi

if [ -z "$5" ]; then
  echo "Usage: $0 <VERSION_ID>"
  exit 1
fi

APP_ID=$4

sql "${CONN}" <<EOF
cd apexlab/f$APP_ID
project release -version "$5"
exit;
EOF