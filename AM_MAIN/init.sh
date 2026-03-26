
#!/bin/bash
# Connect to Oracle database (non-interactive, just for demonstration)
sqlplus AM_MAIN/ae9ae12b4e1c776496ab6c7190y@scdp.ora.netcologne.intern:1521/scdp.netcologne.intern <<EOF
-- You can put SQL commands here if needed

# Project initialization
Project init -name rk_main -schemas am_main

# !git operations
!git add .
!git commit -m "init"
!git push

# Project export
Project export
!git add .
!git commit -m "export"
!git push
# Project stage
Project stage
!git add .
!git commit -m "stage"
!git push

# Project release
project release -version 1.0 -verbose
!git add .
!git commit -m "release"
!git push
# Generate artifact
project gen-artifact -version 1.0
!git add .
!git commit -m "artifact"
!git push

# Liquibase changelog sync
liquibase changelog-sync -chf dist/releases/main.changelog.xml
EXIT
EOF
