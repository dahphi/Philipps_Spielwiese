-- liquibase formatted sql
-- changeset RK_MAIN:1774554915875 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_system.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_system.sql:null:af384f74f628a2f1b1697f69e9cc6ef6607692f6:create

grant select on awh_main.v_hwas_awh_system to rk_main;

grant references on awh_main.v_hwas_awh_system to rk_main;

