
#!/bin/bash
# Connect to Oracle database (non-interactive, just for demonstration)
sql RK_MAIN/RWPy0MnLC_TgvKX2wOqkD2yK5_2zWy@scdt.ora.netcologne.intern:1521/scdt.netcologne.intern <<EOF
-- You can put SQL commands here if needed


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
