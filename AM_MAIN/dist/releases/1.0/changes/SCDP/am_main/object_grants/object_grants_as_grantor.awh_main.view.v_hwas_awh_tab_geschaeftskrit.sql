-- liquibase formatted sql
-- changeset AM_MAIN:1774556574235 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_geschaeftskrit.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_geschaeftskrit.sql:null:7bb164f340637937de1919e0e5c2ac92d8fcf053:create

grant select on awh_main.v_hwas_awh_tab_geschaeftskrit to am_main;

grant references on awh_main.v_hwas_awh_tab_geschaeftskrit to am_main;

