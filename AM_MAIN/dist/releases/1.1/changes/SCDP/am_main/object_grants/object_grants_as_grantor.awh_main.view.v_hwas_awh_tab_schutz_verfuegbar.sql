-- liquibase formatted sql
-- changeset AM_MAIN:1774557122416 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_verfuegbar.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_schutz_verfuegbar.sql:null:d565ad47e0f62da5ed1e74326e498bb5e69558db:create

grant select on awh_main.v_hwas_awh_tab_schutz_verfuegbar to am_main;

grant references on awh_main.v_hwas_awh_tab_schutz_verfuegbar to am_main;

