#!/bin/bash

DB_USER=$1
DB_PASS=$2
DB_HOST=$3
BASE_DIR=$4
APP_ID=$5
VERSION_ID=$6
CONN="${DB_USER}/${DB_PASS}@${DB_HOST}"

if [ -z "$5" ]; then
  echo "Usage: $0 <APP_ID>"
  exit 1
fi

if [ -z "$6" ]; then
  echo "Usage: $0 <VERSION_ID>"
  exit 1
fi

sql "${CONN}" <<EOF
cd $BASE_DIR/f$APP_ID
project release -version "${BASE_DIR}_F${APP_ID}_${VERSION_ID}"
project gen-artifact -version ${BASE_DIR}_F${APP_ID}_${VERSION_ID}
exit;
EOF