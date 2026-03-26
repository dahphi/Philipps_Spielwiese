-- liquibase formatted sql
-- changeset RK_MAIN:1774561689772 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_isr_awh_mtn_sys_vm.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_isr_awh_mtn_sys_vm.sql:null:67f2b65e5351f32b54932ad60f9d2ee55eea7090:create

grant read on awh_main.v_isr_awh_mtn_sys_vm to rk_main;

