-- liquibase formatted sql
-- changeset AM_MAIN:1774557115766 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_bereich_e2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_bereich_e2.sql:null:e734df655ca90571bb63363a62a1c1ce0c9d49d7:create

grant select on am_main.hwas_bereich_e2 to am_apex;

grant select on am_main.hwas_bereich_e2 to awh_apex;

grant select on am_main.hwas_bereich_e2 to rk_apex;

grant read on am_main.hwas_bereich_e2 to awh_read_jira;

