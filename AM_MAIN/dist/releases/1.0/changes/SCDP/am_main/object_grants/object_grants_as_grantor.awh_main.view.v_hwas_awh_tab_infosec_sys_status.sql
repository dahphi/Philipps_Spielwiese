-- liquibase formatted sql
-- changeset AM_MAIN:1774556574240 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_infosec_sys_status.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_infosec_sys_status.sql:null:c67e4f0f345b8e8395b3a79715e855be5dd8fcca:create

grant select on awh_main.v_hwas_awh_tab_infosec_sys_status to am_main;

grant references on awh_main.v_hwas_awh_tab_infosec_sys_status to am_main;

