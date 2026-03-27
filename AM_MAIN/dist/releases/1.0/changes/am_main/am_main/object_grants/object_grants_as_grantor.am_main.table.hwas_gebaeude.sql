-- liquibase formatted sql
-- changeset AM_MAIN:1774600100435 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_gebaeude.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_gebaeude.sql:null:3d27d20f22d0cc24d0c06a279e7ceaab2b13bca9:create

grant select on am_main.hwas_gebaeude to am_apex;

grant select on am_main.hwas_gebaeude to rk_apex;

grant read on am_main.hwas_gebaeude to rk_main;

grant read on am_main.hwas_gebaeude to rk_apex;

grant read on am_main.hwas_gebaeude to awh_read_jira;

