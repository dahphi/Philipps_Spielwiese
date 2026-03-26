-- liquibase formatted sql
-- changeset AM_MAIN:1774556568118 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_raum.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_raum.sql:null:53d1f13e8574ca8b556154dbc56609b56adf9d44:create

grant select on am_main.hwas_raum to am_apex;

grant select on am_main.hwas_raum to rk_apex;

grant read on am_main.hwas_raum to rk_main;

grant read on am_main.hwas_raum to rk_apex;

