#!/bin/bash
set -e

# Usage: ./p3_import_apex_application.sh <DBUSERNAME> <DBPASSWORD> <APEX_APP_ID> <VERSION>
DBUSERNAME="$1"
DBPASSWORD="$2"
CONNECT_STRING="$3"
BASE_DIR="$4"
APEX_APP_ID="$5"
VERSION="$6"

if [[ -z "$DBUSERNAME" || -z "$DBPASSWORD" || -z "$APEX_APP_ID" || -z "$VERSION" ]]; then
  echo "Usage: $0 <DBUSERNAME> <DBPASSWORD> <APEX_APP_ID> <VERSION>"
  exit 1
fi


cd "$BASE_DIR/f${APEX_APP_ID}"
ARTIFACT_NAME="f${APEX_APP_ID}-${BASE_DIR}_F${APEX_APP_ID}_${VERSION}.zip"

sql "$DBUSERNAME/$DBPASSWORD@//$CONNECT_STRING" <<EOF
project gen-artifact -version ${BASE_DIR}_F${APEX_APP_ID}_${VERSION}
project deploy -file artifact/$ARTIFACT_NAME -verbose
exit;
EOF

#rm artifact/f${APEX_APP_ID}-${BASE_DIR}_F${APEX_APP_ID}_${VERSION}.zip