-- liquibase formatted sql
-- changeset AM_MAIN:1774556568135 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_tk_technologie.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_tk_technologie.sql:null:ab4bcd2c9c7aea100c91fdba7805b7aa94cebdd9:create

grant select on am_main.hwas_tk_technologie to am_apex;

grant select on am_main.hwas_tk_technologie to awh_apex;

grant select on am_main.hwas_tk_technologie to rk_apex;

grant read on am_main.hwas_tk_technologie to awh_read_jira;

