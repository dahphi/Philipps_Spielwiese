-- liquibase formatted sql
-- changeset RK_MAIN:1774554915863 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_icl.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_icl.sql:null:12b24e729a05a789eb6247d550a7168fcdff6ec3:create

grant select on awh_main.v_hwas_awh_mtn_sys_icl to rk_main;

grant references on awh_main.v_hwas_awh_mtn_sys_icl to rk_main;

