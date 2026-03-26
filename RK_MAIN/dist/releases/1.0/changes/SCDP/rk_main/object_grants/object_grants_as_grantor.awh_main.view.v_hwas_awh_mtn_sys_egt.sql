-- liquibase formatted sql
-- changeset RK_MAIN:1774554915851 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_egt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_mtn_sys_egt.sql:null:f7d3ffbde525df4e1ef972a724401b8df85791bf:create

grant select on awh_main.v_hwas_awh_mtn_sys_egt to rk_main;

grant references on awh_main.v_hwas_awh_mtn_sys_egt to rk_main;

