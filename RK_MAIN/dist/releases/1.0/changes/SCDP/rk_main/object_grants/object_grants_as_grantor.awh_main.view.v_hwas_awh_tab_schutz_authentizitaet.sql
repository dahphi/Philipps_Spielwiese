-- liquibase formatted sql
-- changeset RK_MAIN:1774561689735 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_authentizitaet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_authentizitaet.sql:null:c26b9b540e236270ada85a1dbf0767d3e9f08519:create

grant select on awh_main.v_hwas_awh_tab_schutz_authentizitaet to rk_main;

grant references on awh_main.v_hwas_awh_tab_schutz_authentizitaet to rk_main;

