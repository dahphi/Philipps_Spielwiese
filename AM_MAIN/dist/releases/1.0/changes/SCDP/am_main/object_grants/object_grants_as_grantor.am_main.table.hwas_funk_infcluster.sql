-- liquibase formatted sql
-- changeset AM_MAIN:1774556567936 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_funk_infcluster.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_funk_infcluster.sql:null:50159ef256753b6770960de5844d0d57c4822edf:create

grant select on am_main.hwas_funk_infcluster to am_apex;

grant read on am_main.hwas_funk_infcluster to awh_read_jira;

