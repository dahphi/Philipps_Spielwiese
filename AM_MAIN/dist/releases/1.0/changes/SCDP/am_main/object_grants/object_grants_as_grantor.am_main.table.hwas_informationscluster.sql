-- liquibase formatted sql
-- changeset AM_MAIN:1774556568025 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_informationscluster.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_informationscluster.sql:null:2c741477ae98e0d2ed9b32cb20d00ba8aa90613c:create

grant select on am_main.hwas_informationscluster to am_apex;

grant select on am_main.hwas_informationscluster to awh_apex;

grant read on am_main.hwas_informationscluster to awh_read_jira;

