-- liquibase formatted sql
-- changeset AM_MAIN:1774556574206 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_egt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_egt.sql:null:44bc980feeba283a841a4e4febb7233f88a57136:create

grant select on awh_main.v_hwas_awh_mtn_sys_egt to am_main;

grant references on awh_main.v_hwas_awh_mtn_sys_egt to am_main;

