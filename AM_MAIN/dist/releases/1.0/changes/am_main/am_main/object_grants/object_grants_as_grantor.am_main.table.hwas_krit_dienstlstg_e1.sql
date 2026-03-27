-- liquibase formatted sql
-- changeset AM_MAIN:1774600100834 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_krit_dienstlstg_e1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_krit_dienstlstg_e1.sql:null:2831aef5c323111bf23b2809ad4d4511c5db77da:create

grant select on am_main.hwas_krit_dienstlstg_e1 to am_apex;

grant select on am_main.hwas_krit_dienstlstg_e1 to awh_apex;

grant select on am_main.hwas_krit_dienstlstg_e1 to rk_apex;

grant read on am_main.hwas_krit_dienstlstg_e1 to awh_read_jira;

