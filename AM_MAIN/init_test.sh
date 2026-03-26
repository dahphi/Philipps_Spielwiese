
#!/bin/bash
# Connect to Oracle database (non-interactive, just for demonstration)
sql AM_MAIN/mPbiFi_lsDGkFjTuZwmHmVZGpmAi8J@scdt.ora.netcologne.intern:1521/scdt.netcologne.intern <<EOF
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


project release -version 1.1 -verbose
!git add .
!git commit -m "release"
!git push

project gen-artifact -version 1.1
!git add .
!git commit -m "artifact"
!git push

EXIT
EOF
