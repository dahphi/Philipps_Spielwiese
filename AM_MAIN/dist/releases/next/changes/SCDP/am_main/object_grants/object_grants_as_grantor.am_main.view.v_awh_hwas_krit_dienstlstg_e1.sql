-- liquibase formatted sql
-- changeset AM_MAIN:1774557116140 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_krit_dienstlstg_e1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_krit_dienstlstg_e1.sql:null:1a3e61638a41ed6c58aa003baff386320f949bea:create

grant select on am_main.v_awh_hwas_krit_dienstlstg_e1 to awh_apex;

grant select on am_main.v_awh_hwas_krit_dienstlstg_e1 to awh_main;

