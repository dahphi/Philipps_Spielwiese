
#!/bin/bash
# Connect to Oracle database (non-interactive, just for demonstration)
sqlplus AM_MAIN/ae9ae12b4e1c776496ab6c7190y@scdp.ora.netcologne.intern:1521/scdp.netcologne.intern <<EOF
-- You can put SQL commands here if needed


Project init -name rk_main -schemas am_main


!git add .
!git commit -m "init"
!git push


Project export
!git add .
!git commit -m "export"
!git push

Project stage
!git add .
!git commit -m "stage"
!git push


project release -version 1.0 -verbose
!git add .
!git commit -m "release"
!git push

project gen-artifact -version 1.0
!git add .
!git commit -m "artifact"
!git push


liquibase changelog-sync -chf dist/releases/main.changelog.xml
EXIT
EOF
