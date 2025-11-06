

set feedback off
set termout off
alter session set NLS_DATE_FORMAT = 'dd.mm.yyyy HH24:mi:ss';
set termout on
set verify off
set serveroutput on
whenever sqlerror exit failure;


spool apexlab.log

show user

select sysdate from dual
/

select * from PRODUCT_COMPONENT_VERSION
/


select sysdate from dual
/

spool off
quit;