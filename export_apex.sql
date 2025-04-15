set serveroutput on;
--Input Variablen
var app_id varchar2(50);
--exec :app_id :=&1;
exec :app_id :='&1';
var version_id varchar2(50);
exec :version_id :='&1' || '_' || '&2';
var commit_msg varchar2(50);
exec :commit_msg :='&3';

define commmit_msg = "Test :app_id";
/*
-- Immer in den develop Branch wechseln und aktuellen Stand ziehen
!git chekout develop
!git pull origin*/
-- Danach den Export des Projektes anstoßen
--project export -o apex.&app_id.;

prompt &1
print version_id
prompt &3

project stage
!git add .
!git commit -m "Staging APEX &commmit_msg";
/*
project release -version &app_id2_0001;
!git add .
!git commit -m "Release APEX 2022 project";
!git push
project gen-artifact -version 2022_2_0001;
!git add .
!git commit -m "Generating APEX 2022 artifact";
!git push
*/