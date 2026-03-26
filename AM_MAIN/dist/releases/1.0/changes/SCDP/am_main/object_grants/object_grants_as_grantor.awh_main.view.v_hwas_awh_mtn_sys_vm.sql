-- liquibase formatted sql
-- changeset AM_MAIN:1774556574224 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_vm.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_vm.sql:null:6a529472d9d2e2fe39dce74ed54cbeda63345df5:create

grant select on awh_main.v_hwas_awh_mtn_sys_vm to am_main;

grant references on awh_main.v_hwas_awh_mtn_sys_vm to am_main;

