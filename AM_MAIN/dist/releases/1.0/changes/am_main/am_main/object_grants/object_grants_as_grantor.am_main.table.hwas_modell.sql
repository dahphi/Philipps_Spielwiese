-- liquibase formatted sql
-- changeset AM_MAIN:1774600100918 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_modell.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_modell.sql:null:f0837e35ff10275e3917d328dc41fccf0ae32a22:create

grant select on am_main.hwas_modell to am_apex;

grant select on am_main.hwas_modell to rk_apex;

grant read on am_main.hwas_modell to rk_main;

grant read on am_main.hwas_modell to rk_apex;

grant read on am_main.hwas_modell to awh_read_jira;

