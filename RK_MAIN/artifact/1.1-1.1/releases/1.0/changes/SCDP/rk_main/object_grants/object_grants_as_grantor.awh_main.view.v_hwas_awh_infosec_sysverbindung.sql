-- liquibase formatted sql
-- changeset RK_MAIN:1774554915844 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_infosec_sysverbindung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_infosec_sysverbindung.sql:null:8f7936d5d2c97956d11875de44c7c716cabeaf95:create

grant select on awh_main.v_hwas_awh_infosec_sysverbindung to rk_main;

grant references on awh_main.v_hwas_awh_infosec_sysverbindung to rk_main;

