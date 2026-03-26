-- liquibase formatted sql
-- changeset AM_MAIN:1774556574218 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_icl.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_icl.sql:null:97061d7ecaa9373215d7b833e53689caec6f25d0:create

grant select on awh_main.v_hwas_awh_mtn_sys_icl to am_main;

grant references on awh_main.v_hwas_awh_mtn_sys_icl to am_main;

