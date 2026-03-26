-- liquibase formatted sql
-- changeset AM_MAIN:1774556567972 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_geraet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_geraet.sql:null:3f2e1430c9bef5726bcc8f270a378c918496e71c:create

grant select on am_main.hwas_geraet to am_apex;

grant select on am_main.hwas_geraet to rk_apex;

grant read on am_main.hwas_geraet to awh_apex;

grant read on am_main.hwas_geraet to rk_main;

grant read on am_main.hwas_geraet to rk_apex;

grant read on am_main.hwas_geraet to awh_read_jira;

grant flashback on am_main.hwas_geraet to am_apex;

