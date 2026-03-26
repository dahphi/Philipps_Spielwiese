-- liquibase formatted sql
-- changeset RK_MAIN:1774555708350 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_vm.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_vm.sql:null:29368f5acfa26566f8a7854c083cf6d484229e9b:create

grant select on awh_main.v_hwas_awh_mtn_sys_vm to rk_main;

grant references on awh_main.v_hwas_awh_mtn_sys_vm to rk_main;

