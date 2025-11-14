#!/bin/bash
set -e

# Usage: ./p3_import_apex_application.sh <DBUSERNAME> <DBPASSWORD> <APEX_APP_ID> <VERSION>
DBUSERNAME="$1"
DBPASSWORD="$2"
CONNECT_STRING="$4"
APEX_APP_ID="$5"
VERSION="$5"

if [[ -z "$DBUSERNAME" || -z "$DBPASSWORD" || -z "$APEX_APP_ID" || -z "$VERSION" ]]; then
  echo "Usage: $0 <DBUSERNAME> <DBPASSWORD> <APEX_APP_ID> <VERSION>"
  exit 1
fi

cd Philipps_Spielwiese/apex/f${APEX_APP_ID}
sql "$DBUSERNAME/$DBPASSWORD@//$CONNECT_STRING" <<EOF
project gen-artifact -version ${VERSION} -force
project deploy -file artifact/f${APEX_APP_ID}-${VERSION}.zip                    
exit;
EOF
rm artifact/f${APEX_APP_ID}-${VERSION}.zip
