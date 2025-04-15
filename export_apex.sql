set serveroutput on;
--Input Variablen
var app_id varchar2(50);
--exec :app_id :=&1;
exec :app_id :='&1';
var version_id varchar2(50);
exec :version_id :='&1' || '_' || '&2';
var commit_msg varchar2(50);
exec :commit_msg :='&3';

define commmit_msg = "Test &1";
project export -o apex.&app_id.;
prompt &1
print version_id
prompt &3

project stage
project release -version :version_id;
project gen-artifact -version :version_id;
!git add .
!git commit -m "Staging APEX &commmit_msg";
!git push
*/