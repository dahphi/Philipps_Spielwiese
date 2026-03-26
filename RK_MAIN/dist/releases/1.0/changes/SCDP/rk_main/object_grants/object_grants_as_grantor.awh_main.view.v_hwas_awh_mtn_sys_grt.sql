-- liquibase formatted sql
-- changeset RK_MAIN:1774554915857 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_grt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_grt.sql:null:787d81ad8d9edc12804e853bba8acc41521734ab:create

grant select on awh_main.v_hwas_awh_mtn_sys_grt to rk_main;

grant references on awh_main.v_hwas_awh_mtn_sys_grt to rk_main;

