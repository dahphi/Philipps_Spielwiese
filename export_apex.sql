set serveroutput on;

define version_id1 = "&1._&2";
define commmit_msg = "Test &1";
project export -o apex.&1;
project stage
project release -version &version_id1;
project gen-artifact -version &version_id1;
!git add .
!git commit -m "Export APEX APP: &commmit_msg";
!git push
