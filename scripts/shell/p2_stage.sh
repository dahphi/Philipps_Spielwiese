#!/bin/bash

DB_USER=$1
DB_PASS=$2
DB_HOST=$3
CONN="${DB_USER}/${DB_PASS}@${DB_HOST}"

if [ -z "$4" ]; then
  echo "Usage: $0 <APP_ID>"
  exit 1
fi

APP_ID=$4

sql "${CONN}" <<EOF
cd apex/f$APP_ID
project stage
exit;
EOF