#!/bin/bash
set -e

# Usage: ./p1_initialize_project.sh <DBUSERNAME> <DBPASSWORD> <APEX_APP_ID>
DBUSERNAME="$1"
DBPASSWORD="$2"
CONNECT_STRING="$3"
APEX_APP_ID="$4"

if [[ -z "$DBUSERNAME" || -z "$DBPASSWORD" || -z "$APEX_APP_ID" ]]; then
  echo "Usage: $0 <DBUSERNAME> <DBPASSWORD> <APEX_APP_ID>"
  exit 1
fi

APP_FOLDER="apex/f${APEX_APP_ID}"
if [ ! -d "$APP_FOLDER" ]; then
    mkdir -p "$APP_FOLDER"
    echo "Created folder: $APP_FOLDER"
    cd "$APP_FOLDER"
    sql "$DBUSERNAME/$DBPASSWORD@//$CONNECT_STRING" <<EOF
project init -name f${APEX_APP_ID} -schemas $DBUSERNAME
exit;
EOF
    cd - >/dev/null
fi
