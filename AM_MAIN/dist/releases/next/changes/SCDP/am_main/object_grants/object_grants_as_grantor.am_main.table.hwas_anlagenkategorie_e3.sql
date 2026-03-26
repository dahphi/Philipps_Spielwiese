-- liquibase formatted sql
-- changeset AM_MAIN:1774556567870 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_anlagenkategorie_e3.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_anlagenkategorie_e3.sql:null:7db14725cd9603a9a6cdc3b36dd42c360b42704b:create

grant select on am_main.hwas_anlagenkategorie_e3 to am_apex;

grant select on am_main.hwas_anlagenkategorie_e3 to awh_apex;

grant select on am_main.hwas_anlagenkategorie_e3 to rk_apex;

grant read on am_main.hwas_anlagenkategorie_e3 to awh_read_jira;

