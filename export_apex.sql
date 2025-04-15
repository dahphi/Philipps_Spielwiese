set serveroutput on;
--Input Variablen
var app_id varchar2(50);
--exec :app_id :=&1;
exec :app_id :='&1';
var version_id varchar2(50);
exec :version_id :='&1' || '_' || '&2';
var commit_msg varchar2(50);
exec :commit_msg :='&3';

define version_id1 = "&1._&2";
define commmit_msg = "Test &1";
project export -o apex.&1;
prompt &1
print version_id
prompt &3

project stage
project release -version &version_id1;
project gen-artifact -version &version_id1;
!git add .
!git commit -m "Export APEX APP: &commmit_msg";
!git push
