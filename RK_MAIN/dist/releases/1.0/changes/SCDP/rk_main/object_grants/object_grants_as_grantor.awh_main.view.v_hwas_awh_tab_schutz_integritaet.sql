-- liquibase formatted sql
-- changeset RK_MAIN:1774561689741 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_integritaet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_integritaet.sql:null:294d5550d978c95d32d69eaebfa5ab13e0b9182d:create

grant select on awh_main.v_hwas_awh_tab_schutz_integritaet to rk_main;

grant references on awh_main.v_hwas_awh_tab_schutz_integritaet to rk_main;

