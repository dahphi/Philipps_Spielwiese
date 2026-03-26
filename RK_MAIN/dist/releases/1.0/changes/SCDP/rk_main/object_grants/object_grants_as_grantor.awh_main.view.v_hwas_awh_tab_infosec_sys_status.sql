-- liquibase formatted sql
-- changeset RK_MAIN:1774561689730 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_infosec_sys_status.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_infosec_sys_status.sql:null:e604006c987215693f8f4243ed8569c7df421280:create

grant select on awh_main.v_hwas_awh_tab_infosec_sys_status to rk_main;

grant references on awh_main.v_hwas_awh_tab_infosec_sys_status to rk_main;

