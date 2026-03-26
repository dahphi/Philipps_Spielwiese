-- liquibase formatted sql
-- changeset AM_MAIN:1774556574212 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_grt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_grt.sql:null:b6e2362a611777ff0c3e252b06f795b2e14c4dd1:create

grant select on awh_main.v_hwas_awh_mtn_sys_grt to am_main;

grant references on awh_main.v_hwas_awh_mtn_sys_grt to am_main;

