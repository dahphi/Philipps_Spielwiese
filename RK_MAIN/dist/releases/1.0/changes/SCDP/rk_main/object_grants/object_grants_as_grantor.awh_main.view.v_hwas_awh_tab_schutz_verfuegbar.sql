-- liquibase formatted sql
-- changeset RK_MAIN:1774554915906 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_verfuegbar.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_verfuegbar.sql:null:d4a3ac162baa7eb4835be6aa24fcf9aabfdee191:create

grant select on awh_main.v_hwas_awh_tab_schutz_verfuegbar to rk_main;

grant references on awh_main.v_hwas_awh_tab_schutz_verfuegbar to rk_main;

