-- liquibase formatted sql
-- changeset AM_MAIN:1774600129489 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_integritaet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_integritaet.sql:null:aa7e5763bc14fd8487b3aed5e870033c8339a439:create

grant select on awh_main.v_hwas_awh_tab_schutz_integritaet to am_main;

grant references on awh_main.v_hwas_awh_tab_schutz_integritaet to am_main;

