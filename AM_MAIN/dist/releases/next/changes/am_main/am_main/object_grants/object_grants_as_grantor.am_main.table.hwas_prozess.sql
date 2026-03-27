-- liquibase formatted sql
-- changeset AM_MAIN:1774600101099 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_prozess.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_prozess.sql:null:f16f7a92eb636571968db6d5060e0528839f603e:create

grant select on am_main.hwas_prozess to am_apex;

grant select on am_main.hwas_prozess to awh_apex;

grant read on am_main.hwas_prozess to awh_read_jira;

