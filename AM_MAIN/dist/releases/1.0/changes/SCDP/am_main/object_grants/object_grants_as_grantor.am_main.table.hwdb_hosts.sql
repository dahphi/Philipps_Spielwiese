-- liquibase formatted sql
-- changeset AM_MAIN:1774556568173 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwdb_hosts.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwdb_hosts.sql:null:f75e06fd9f1a706cec3b8a4fbfb8bbe435b547f8:create

grant select on am_main.hwdb_hosts to am_apex;

grant select on am_main.hwdb_hosts to rk_apex;

grant read on am_main.hwdb_hosts to awh_apex;

grant read on am_main.hwdb_hosts to rk_main;

grant read on am_main.hwdb_hosts to rk_apex;

grant read on am_main.hwdb_hosts to awh_read_jira;

