-- liquibase formatted sql
-- changeset RK_MAIN:1774561689768 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_isr_awh_mtn_sys_grt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_isr_awh_mtn_sys_grt.sql:null:6e11d306d73f92a3546e97799b4ad9b9dbe13e45:create

grant read on awh_main.v_isr_awh_mtn_sys_grt to rk_main;

