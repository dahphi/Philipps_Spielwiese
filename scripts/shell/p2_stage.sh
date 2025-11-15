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

sql "${CONN}" <<EOF
cd $BASE_DIR/f$APP_ID
project stage -verbose
exit;
EOF