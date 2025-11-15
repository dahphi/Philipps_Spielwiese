#!/bin/bash
set -e

# Usage: ./p1_initialize_project.sh <DBUSERNAME> <DBPASSWORD> <CONNECT_STRING> <TARGET_DATABASE> <APEX_APP_ID>
DBUSERNAME="$1"
DBPASSWORD="$2"
CONNECT_STRING="$3"
TARGET_DATABASE="$4"
APEX_APP_ID="$5"

if [[ -z "$DBUSERNAME" || -z "$DBPASSWORD" || -z "$CONNECT_STRING" || -z "$TARGET_DATABASE" || -z "$APEX_APP_ID" ]]; then
  echo "Usage: $0 <DBUSERNAME> <DBPASSWORD> <CONNECT_STRING> <TARGET_DATABASE> <APEX_APP_ID>"
  exit 1
fi

BASE_FOLDER="${TARGET_DATABASE}"
APP_FOLDER="${BASE_FOLDER}/f${APEX_APP_ID}"

# Check and create base folder if it doesn't exist
if [ ! -d "$BASE_FOLDER" ]; then
    mkdir -p "$BASE_FOLDER"
    echo "Created base folder: $BASE_FOLDER"
fi

# Check and create app folder if it doesn't exist
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
